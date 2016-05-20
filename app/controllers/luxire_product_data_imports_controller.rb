class LuxireProductDataImportsController < ApplicationController

respond_to :html, :json
NOT_AVAILABLE = "NA"

    def import
      file = params[:file]
      @count = 0
      @buggy_record = Hash.new
      CSV.foreach(file.path, headers: true, encoding: 'ISO-8859-1') do |row|

          @count += 1
          assign_values(row)
          begin
            Spree::Product.transaction do
              if row["Parent SKU"].casecmp(NOT_AVAILABLE) == 0 || row["Parent SKU"].blank?
                raise 'Inventory is not defined'
              else
                luxire_stocks = LuxireStock.where('lower(parent_sku) = ?',row["Parent SKU"].downcase )
                if luxire_stocks.empty?
                  @luxire_stock = LuxireStock.new
                  set_inventory(row)
                 else
                   @luxire_stock = luxire_stocks.first
                   set_inventory(row)
                   end
                end

              if( !(row["Type"].casecmp(NOT_AVAILABLE) == 0) && !row["Type"].blank?)
                  product_types = LuxireProductType.where('lower(product_type) = ?', row["Type"].downcase)
                  if product_types.empty?
                    raise "#{row['Type']} product_type does not exist"
                  else
                     @product_type = product_types.first
                     @luxire_product[:luxire_product_type_id] = @product_type.id
                  end
                else
                  raise 'No product type mentioned'
              end


             @product.save!
             @luxire_product[:product_id] = @product.id

             @variant = @product.master
             @variant[:track_inventory] = false
             @variant[:sku] = row["Variant SKU"]
             @variant[:weight] = row["Variant Grams"]
             @variant.save!

             if( !(row["Vendor"].casecmp(NOT_AVAILABLE) == 0) && !row["Vendor"].blank?)
               vendor_masters = LuxireVendorMaster.where('lower(name) = ?', row["Vendor"].downcase)
               if vendor_masters.empty?
                 @vendor_master = LuxireVendorMaster.new
                 @vendor_master[:name] = row["Vendor"]
                 @vendor_master.save!
               else
                 @vendor_master = vendor_masters.first
             end
             @luxire_product[:luxire_vendor_master_id] = @vendor_master.id
            end
            #
            # if !row["Current Luxire Site collections"].casecmp(NOT_AVAILABLE) == 0 && !row["Current Luxire Site collections"].blank?
            #     taxons = row["Current Luxire Site collections"].split(",")
            #     ids = []
            #     taxons.each do |taxon|
            #       spree_taxon = Spree::Taxon.where('lower(name) = ?', taxon.downcase)
            #       if spree_taxon.empty?
            #         raise '#{taxon} not found'
            #       else
            #         ids << spree_taxon.first.id
            #       end
            #     end
            #     @product.taxon_ids= ids
            #     @product.save!
            #   end
             @luxire_product.save!
             set_up_options
             associate_collection(row)
             create_swatch_variant(row)

             if ( !(row["Image Src"].casecmp(NOT_AVAILABLE) == 0) && !row["Image Src"].blank?)
               image_sources = row["Image Src"].split(",").map(&:strip)
               image_sources.each do |image_source|
                 @image = Spree::Image.new
                 @image.attachment= URI.parse(image_source)
                 @image.viewable = @variant
                 @image.save!
               end
             end

            end

          rescue Exception => exception
             name = "#{@count}  #{row['Handle']}"
             @buggy_record[name] = exception.message
        end
      end
      logger.debug "Buggy record length is " + @buggy_record.length.to_s
      response = {count: @count, buggy_record: @buggy_record}

      respond_with do |format|
        format.html { render 'luxire_product_data_imports/show.html.erb'}
        format.json { render json: response.to_json, status: "200" }
      end

      # render json: response.to_json, status: "200"
      # render 'luxire_product_data_imports/show.html.erb'
    end

    private
    def assign_values(row)

      available_date = Time.now

      if ( !(row["Published Date"].casecmp(NOT_AVAILABLE) == 0) && !row["Published Date"].empty?)
        published_date = row["Published Date"]
        available_date = Date.strptime(published_date, "%d/%m/%Y")
      end

      product_hash = {name: row["Title"], available_on: available_date, price: row["Variant Price"], description: row["Body (HTML) Leave Blank"], shipping_category_id: 1}
      @product = Spree::Product.new(product_hash)
      @luxire_product = LuxireProduct.new
      # Set the req_validation to true to set the validation
      @luxire_product.req_validation = true
      @option_arr = []

=begin
      @product[:name] = row["Title"]
      @product[:description] = row["Body (HTML)"]
      @product[:price] = row["Variant Price"]
      @product[:shipping_category_id] = 1
=end
      option1  = row["Option1 Name"]
      value1 = row["Option1 Value"]
      option2 = row["Option2 Name"]
      value2  = row["Option2 Value"]
      option3  = row["Option3 Name"]
      value3  = row["Option3 Value"]

      @options_attrs = Hash.new(0)

      @options_attrs [option1.to_s] = value1  unless option1.blank? || option1.casecmp(NOT_AVAILABLE) == 0
      @options_attrs [option2.to_s] = value2  unless option2.blank? || option1.casecmp(NOT_AVAILABLE) == 0
      @options_attrs [option3.to_s] = value3  unless option3.blank? || option1.casecmp(NOT_AVAILABLE) == 0

      unless @options_attrs.empty?
        @option_arr << @options_attrs
      end

      @luxire_product[:handle] = row["Handle"]

      @luxire_product[:product_tags] = row["Tag"]
      @luxire_product[:product_compare_at_price] = row["Variant Compare At Price"]
      @luxire_product[:barcode] = row["Variant Barcode"]
      @luxire_product[:gift_card_flag] = row["Gift Card"]
      @luxire_product[:product_weave_type] = row["Types of weave"]
      @luxire_product[:no_of_color] = row["No. of colors"]
      @luxire_product[:product_color] = row["Color name"]
      @luxire_product[:usage] = row["Usage"]
      @luxire_product[:pattern] = row["Design: Stripes/Checks/ etc"]
      @luxire_product[:country_of_origin] = row["Country of Origin"]
      @luxire_product[:mill] = row["Mill"]
      @luxire_product[:suitable_climates]  = row["Seasons (Summer, Autumn, Winter, Spring)"]
      @luxire_product[:construction] = row["construction (Number of threads in warp and weft)"]
      @luxire_product[:thread_count] = row["Count (Thickness of thread used like 40s, 120/2 etc)"]
      @luxire_product[:thickness] = row["Thickness"]
      @luxire_product[:stiffness] = row["Stiffness"].to_f
      @luxire_product[:gsm] = row["GSM"]
      @luxire_product[:glm] = row["GLM"]
      @luxire_product[:wash_care] = row["Wash Care"]
      @luxire_product[:shrinkage] = row["Shrinkage"].to_i
      @luxire_product[:composition] = row["Material Composition with %"]
      @luxire_product[:technical_description] = row["Technical Description"]
      @luxire_product[:sales_pitch] = row["Sales Pitch"]
      @luxire_product[:related_fabric] = row["Related/Similar Fabric"]
      @luxire_product[:length_required] = row["Length Required"]
      @luxire_product[:transparency] = row["Transparency"]
      @luxire_product[:wrinkle_resistance] = row["Wrinkle Resistance"]
      @luxire_product[:wash_care]  = row["Wash Care"]
      @luxire_product[:stiffness]  = row["Stiffness"]
      @luxire_product[:stiffness_unit]  = row["Stiffness"].gsub(row["Stiffness"].to_f.to_s,"")

      @luxire_product[:variant_taxable] = row["Variant Taxable"]
      @luxire_product[:variant_require_shipping] = row["Variant Requires Shipping"]
      @luxire_product[:variant_fulfillment_service] = row["Variant Fulfillment Service"]
      # @luxire_product[:material] = row[""]
      @luxire_product[:inventory_tracked_by] = row["Variant Inventory Tracker"]

      # Luxire_stock[:virtual_count_on_hands], Luxire_stock[:physical_count_on_hands] = row["Variant Inventory Qty"]


    end

    def set_up_options
                @option_arr.each do |option|
                      option.each do |name,value|
                          option_type = Spree::OptionType.where('lower(name) = ?', name.downcase).first_or_initialize do |option_type|
                            option_type.presentation = name
                            option_type.save!
                            end

                       optionValue = Spree::OptionValue.where('lower(name) = ?', value.downcase).first_or_initialize do |optionValue|
                            optionValue.name = value || optionValue.name
                            optionValue.option_type_id = option_type.id || optionValue.option_type_id
                            optionValue.presentation = optionValue || optionValue.presentation
                            optionValue.save!
                          end

                      unless product.option_types.include?(option_type)
                        product.option_types << option_type
                      end
                    end
                end
    end

    def create_swatch_variant(row)
      price = 1
      sku = "SWT_#{@product.sku}"
      @swatch_properties = Hash.new
      @swatch_properties[:product_id] = @product.id
      @swatch_properties[:sku] = sku
      @swatch_properties[:price] = row["Swatch Price"]
      @swatch_properties[:track_inventory] = false
      @swatch_variant = Spree::Variant.new(@swatch_properties)
      @swatch_variant.save!
      unless row["Swatch Image"].casecmp(NOT_AVAILABLE) == 0 || row["Swatch Image"].blank?
        @image = Spree::Image.new
        @image.attachment= URI.parse(row["Swatch Image"])
        @image.viewable = @swatch_variant
        @image.save!
      end
    end

    def set_inventory(row)
      if ((row["Inventory in meters if Inhouse"].casecmp(NOT_AVAILABLE) == 0 || row["Inventory in meters if Inhouse"].empty?)  && (row["If Mill Sourced, Current Luxire Stock"].casecmp(NOT_AVAILABLE) == 0 || row["If Mill Sourced, Current Luxire Stock"].empty?))
        raise 'Inventory not defined'
      elsif( !(row["Inventory in meters if Inhouse"].casecmp(NOT_AVAILABLE) == 0) && ( !row["Inventory in meters if Inhouse"].empty?))
        @luxire_stock.virtual_count_on_hands = row["Inventory in meters if Inhouse"].to_f
        @luxire_stock.physical_count_on_hands = row["Inventory in meters if Inhouse"].to_f
        @luxire_stock.in_house = true
      elsif( !(row["If Mill Sourced, Current Luxire Stock"].casecmp(NOT_AVAILABLE) == 0) && !row["If Mill Sourced, Current Luxire Stock"].empty?)
        @luxire_stock.in_house = false
        @luxire_stock.virtual_count_on_hands = row["If Mill Sourced, Current Luxire Stock"].to_f
        @luxire_stock.physical_count_on_hands = row["If Mill Sourced, Current Luxire Stock"].to_f
      end
      @luxire_stock.threshold = row["Threshold"]
      @luxire_stock.fabric_width = row["Fabric Width"]
      @luxire_stock.backorderable = row["Variant Inventory Policy"]
      @luxire_stock.measuring_unit = row["Inventory Measuring Unit"]
      @luxire_stock.stock_location_id = 1
      @luxire_stock.rack = row["Inventory Rack"]
      @luxire_stock.backorderable = row["Inventory Backoderable"]
      @luxire_stock.parent_sku = row["Parent SKU"]
      @luxire_stock.save!
      @luxire_product.luxire_stock_id = @luxire_stock.id
    end

    def associate_collection(row)
      if ( !(row["Current Luxire Site collections"].casecmp(NOT_AVAILABLE) == 0) && !row["Current Luxire Site collections"].empty? )
        collections = row["Current Luxire Site collections"].split(",").map(&:strip)
        ids = []
        collections.each do |collection|
          collection_hierarchy = collection.split("->").map(&:strip)
          taxonomy_name = collection_hierarchy.first
          taxonomy = Spree::Taxonomy.where('lower(name) = ?', collection_hierarchy.first.downcase).first

          if taxonomy
            collection_hierarchy.drop(1).each_with_index do |hierarchy, count|
              @taxon = taxonomy.taxons.where('lower(name) = ?', hierarchy.downcase).where(depth: count+1).first
              unless @taxon
                info = collection_hierarchy[0]
                for i in 1..count
                  info+= "->"  + collection_hierarchy[i]
                end
                raise "#{taxonomy_name} -> #{info} collection does not exist"
              end
            end
          else
            raise "#{collection_hierarchy} collection does not exist"
          end
          if collection_hierarchy.length == 0
            id = taxonomy.taxons.first.id
          else
            id = @taxon.id
          end
          ids << id
        end
        @product.taxon_ids = ids
        @product.save!
      end
    end
end
