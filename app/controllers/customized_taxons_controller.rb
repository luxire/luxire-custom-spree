class CustomizedTaxonsController < Spree::Api::BaseController
        before_action :load_taxonomy, only: [:create, :edit, :update]
        before_action :load_taxon, only: [:edit, :update]
        respond_to :html, :json, :js

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
          if !params[:permalink].empty?
              params[:permalink].gsub!("-"," ")
              collection_hierarchy = params[:permalink].split("/")
              @taxonomy = Spree::Taxonomy.where('lower(name) = ?', collection_hierarchy.first.downcase).first

              if @taxonomy
                collection_hierarchy.drop(1).each_with_index do |hierarchy, count|
                    @taxon = @taxonomy.taxons.where('lower(name) = ?', hierarchy.downcase).where(depth: count+1).first
                    unless @taxon
                        response =  {msg: "#{hierarchy} collection does not exist"}
                        render json: response.to_json, status: "200"
                        return
                    end
                 end
              else
                response =  {msg: "#{collection_hierarchy.first} collection does not exist"}
                render json: response.to_json, status: "200"
                return
              end
          end
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
