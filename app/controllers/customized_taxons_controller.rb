class CustomizedTaxonsController < Spree::Api::BaseController
        before_action :load_taxonomy, only: [:create, :edit, :update]
        before_action :load_taxon, only: [:edit, :update]
        respond_to :html, :json, :js

        wrap_parameters format: [:json, :xml, :url_encoded_form, :multipart_form]
        wrap_parameters :taxon, include: [ :id, :parent_id, :icon]

        def initialize
          @path = 'spree/admin/taxons'
          @name = 'taxons'
        end

        def index

        end

        def search
          if params[:ids]
            @taxons = Spree::Taxon.where(:id => params[:ids].split(','))
          else
            @taxons = Spree::Taxon.limit(20).ransack(:name_cont => params[:q]).result
          end
        end

        def create
          @taxon = @taxonomy.taxons.build(params[:taxon])
          if @taxon.save
            respond_with(@taxon) do |format|
              format.json {render :json => @taxon.to_json }
            end
          else
            # flash[:error] = Spree.t('errors.messages.could_not_create_taxon')
            resp = {msg: 'errors.messages.could_not_create_taxon'}
            respond_with(@taxon) do |format|
              format.html { redirect_to @taxonomy ? edit_admin_taxonomy_url(@taxonomy) : admin_taxonomies_url }
              format.json { render json: @taxon.to_json, status: "422" }
            end
          end
        end

        def edit
          @permalink_part = @taxon.permalink.split("/").last
        end

        def update
          parent_id = params[:taxon][:parent_id]
          set_position
          set_parent(parent_id)

          @taxon.save!

          # regenerate permalink
          regenerate_permalink if parent_id

          set_permalink_params

          #check if we need to rename child taxons if parent name or permalink changes
          @update_children = true if params[:taxon][:name] != @taxon.name || params[:taxon][:permalink] != @taxon.permalink

          if @taxon.update_attributes(taxon_params)
            # flash[:success] = flash_message_for(@taxon, :successfully_updated)
          end

          #rename child taxons
          rename_child_taxons if @update_children

          respond_with(@taxon) do |format|
            format.html {redirect_to edit_admin_taxonomy_url(@taxonomy) }
            format.json {render :json => @taxon.to_json }
          end
        end

        def destroy
          @taxon = Taxon.find(params[:id])
          @taxon.destroy
          respond_with(@taxon) { |format| format.json { render :json => '' } }
        end

        def get_taxon_details
          unless params[:permalink].empty?
            # We need to check whether the permalink hierarchy is correct or not.
            # split permalink based on "/"
              collection_hierarchy = params[:permalink].split("/")
            # Find the root_taxon. The first word of the permalink specifies the root taxon
              root_taxon = Spree::Taxon.where('lower(permalink) = ?', collection_hierarchy.first.downcase).first
            # If root_taxon does not exist respond with root_taxon does not exist
            # Else find the taxonomy
              if root_taxon.nil?
                response =  {msg: "#{collection_hierarchy.first} collection does not exist"}
                render json: response.to_json, status: "422"
                return
              end
              @taxonomy = root_taxon.taxonomy
            # Create the full_hierarcy variable and assign it to the first element of the collection_hierarchy array.
              full_hierarcy = collection_hierarchy.first
              if @taxonomy
                # Drop the first element of the collection_hierarchy array and iterate over it
                # And check whether the taxon exist or not
                collection_hierarchy.drop(1).each_with_index do |hierarchy, count|
                  full_hierarcy = "#{full_hierarcy}/#{hierarchy}"
                    @taxon = @taxonomy.taxons.where('lower(permalink) = ?', full_hierarcy.downcase).where(depth: count+1).first
                    unless @taxon
                        response =  {msg: "#{hierarchy} collection does not exist"}
                        render json: response.to_json, status: "422"
                        return
                    end
                 end
              else
                response =  {msg: "#{collection_hierarchy.first} collection does not exist"}
                render json: response.to_json, status: "422"
                return
              end
          else
            response =  {msg: "params[:permalink] can not be empty?"}
            render json: response.to_json, status: "422"
            return
          end
          # Created an array product_ids which will hold all the product_id
          product_ids = []
          # Use the regular expression % at the end which will find all taxon whose permalink starts with
          # the user inserted permalink(params[:permalink]) and can have any values after it.
          permalink  = "#{params[:permalink]}%"
          # Iterate over the Taxon's array of objects and populate the product_ids array
          Spree::Taxon.where('lower(permalink) like (?)',permalink.downcase).each do |taxon|
            product_ids += taxon.product_ids
          end
          @products = Spree::Product.find(product_ids)
          render "get_taxon_details"
        end

        private

        def taxon_params
          params.require(:taxon).permit(permitted_taxon_attributes)
        end

        def load_taxon
          @taxon = @taxonomy.taxons.find(params[:id])
        end

        def load_taxonomy
          @taxonomy = Spree::Taxonomy.find(params[:taxonomy_id])
        end

        def set_position
          new_position = params[:taxon][:position]
          if new_position
            @taxon.child_index = new_position.to_i
          end
        end

        def set_parent(parent_id)
          if parent_id
            @taxon.parent = Taxon.find(parent_id.to_i)
          end
        end

        def set_permalink_params
          if params.key? "permalink_part"
            parent_permalink = @taxon.permalink.split("/")[0...-1].join("/")
            parent_permalink += "/" unless parent_permalink.blank?
            params[:taxon][:permalink] = parent_permalink + params[:permalink_part]
          end
        end

        def rename_child_taxons
          @taxon.descendants.each do |taxon|
            taxon.reload
            taxon.set_permalink
            taxon.save!
          end
        end

        def regenerate_permalink
          @taxon.reload
          @taxon.set_permalink
          @taxon.save!
          @update_children = true
        end
end
