class LuxireProductDataImportsController < ApplicationController

before_action :validate_csv_format, only: [:import]
after_action :populate_product_price_in_multi_currency, only: [:import]
after_action :send_error_list_to_admin, only: [:import], if: :buggy_record_length

respond_to :html, :json
NOT_AVAILABLE = "NA"
NODE_URL = "http://luxire.cloudhop.in:9090/api/redis/product_sync"
EXPECTED_HEADER = ["Handle", "Inventory Rack", "Inventory Backoderable", "CURRENT LUXIRE SITE HANDLE", "Image Src", "Image Src 1", "Image Src 2", "Image Src 3", "Image Src 4", "Image Src 5", "Image Src 6", "Title", "Types of weave", "No. of colors", "Color name", "Tag", "Material Composition with %", "Usage", "Design: Stripes/Checks etc", "Country of Origin", "Mill", "Seasons (Summer, Autumn, Winter, Spring)", "Construction ", "Count ", "Thickness", "Stiffness", "GSM", "Ounces", "GLM", "Wash Care", "Shrinkage", "Technical Description", "Sales Pitch", "Related/Similar Fabric", "Vendor", "Primary Usage", "Type", "Variant SKU", "Parent SKU", "Variant Grams", "Variant Inventory Tracker", "Inventory in meters if Inhouse", "Stock Storage", "If Mill Sourced, Current Luxire Stock", "Variant Inventory Qty LEAVE BLANK", "Variant Inventory Policy", "Variant Fulfillment Service", "Swatch price", "Variant Price", "Variant compare at price", "Variant Requires Shipping", "Variant Taxable", "Length Required", "Threshold", "Inventory Measuring Unit", "Fabric Width", "Swatch Image", "Published Date", "Variant Barcode", "Gift Card", "Transparency", "Wrinkle Resistance"]

    def import
      file = params[:file]
      @count = 0
      @buggy_record = Hash.new
      @product_ids = []
      CSV.foreach(file.path, headers: true, encoding: 'ISO-8859-1') do |row|
          @count += 1
          begin
            validate_record(row)
            assign_values(row) if (row["Gift Card"].blank? || (row["Gift Card"].to_s.casecmp("false") == 0))
            check_for_images(row)
            Spree::Product.transaction do
	     # byebug
              if row["Variant SKU"].blank? || row["Variant SKU"].casecmp(NOT_AVAILABLE) == 0
                raise 'Variant SKU is not defined'
              else
                luxire_stocks = LuxireStock.where('lower(parent_sku) = ?',row["Variant SKU"].downcase )
  		#byebug
                if luxire_stocks.empty?
                  @luxire_stock = LuxireStock.new
                  set_inventory(row)
                 else
                   @luxire_stock = luxire_stocks.first
                   set_inventory(row)
                   end
                end

              if(!row["Type"].blank? && !(row["Type"].casecmp(NOT_AVAILABLE) == 0))
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

             @variant = @product.master
             @variant[:track_inventory] = false
             @variant[:weight] = row["Variant Grams"]
             set_variant_sku(row)
             @variant.save!

             if (row["Gift Card"].blank? || (row["Gift Card"].to_s.casecmp("false") == 0))
                 @luxire_product[:product_id] = @product.id

                 if( !row["Vendor"].blank? && !(row["Vendor"].casecmp(NOT_AVAILABLE) == 0) )
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
                 create_swatch_variant(row)
               end

                 associate_collection(row)
		# byebug
            image_count = 0
            image_source = "Image Src"
            while(image_count < 7)
              image_source ="Image Src{image_count}" unless image_count == 0
              begin
                if ( !row[image_source].blank? && !(row[image_source].casecmp(NOT_AVAILABLE) == 0))
                  image = row[image_source]
                  image.sub!("_grande") if row[image_source].include? ("_grande.")
                  image.sub!(/\d+X\d+\./, "")
                  populate_image(image)
                end
                image_count += 1
              rescue TypeError
                raise "Image url not correct #{row[image_source]}"
              rescue OpenURI::HTTPError
                raise "No image found for #{row[image_source]}"
              end
            end
             @product_ids << @product.id
            end
          rescue Exception => exception
             name = "#{@count}  #{row['Handle']}"
             @buggy_record[name] = exception.message
        end
      end
      # Call the API to fetch data
      # unless @product_ids.empty?
      #   url = URI.parse(NODE_URL)
      #   params = {"ids[]" =>@product_ids}
      #   response = Net::HTTP.post_form(url,params)
      # if response.code == "200"
      #   logger.debug "Redis updated successfully"
      # else
      #   logger.error "Error while updating redis"
      # end
      # end
      logger.debug "Product ids are #{@product_ids}"
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

      if ( !row["Published Date"].blank? && !(row["Published Date"].casecmp(NOT_AVAILABLE) == 0))
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
      # @luxire_product[:gift_card_flag] = row["Gift Card"]
      @luxire_product[:product_weave_type] = row["Types of weave"]
      @luxire_product[:no_of_color] = row["No. of colors"]
      @luxire_product[:product_color] = row["Color name"]
      @luxire_product[:usage] = row["Usage"]
      if !row["Design: Stripes/Checks etc"].nil? && row["Design: Stripes/Checks etc"].downcase == "plaid"
        @luxire_product[:pattern] = "#{row["Design: Stripes/Checks etc"]},checks"
      else
        @luxire_product[:pattern] = row["Design: Stripes/Checks etc"]
      end
      @luxire_product[:country_of_origin] = row["Country of Origin"]
      if row["Mill"].blank? || row["Mill"].casecmp(NOT_AVAILABLE) == 0
        @luxire_product[:mill] = "Luxire"
      else
        @luxire_product[:mill] = row["Mill"]
      end
      @luxire_product[:mill] = row["Mill"] || "Luxire"
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
     # @luxire_product[:length_required] = row["Length Required"]
      @luxire_product[:transparency] = row["Transparency"]
      @luxire_product[:wrinkle_resistance] = row["Wrinkle Resistance"]
      @luxire_product[:wash_care]  = row["Wash Care"]
      @luxire_product[:stiffness]  = row["Stiffness"]
      unless row["Stiffness"].blank? || row["Stiffness"].casecmp(NOT_AVAILABLE) == 0
        @luxire_product[:stiffness_unit]  = row["Stiffness"].gsub(row["Stiffness"].to_f.to_s,"")
      end
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
      @swatch_properties[:price] = row["Swatch price"]
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
     # @luxire_stock.parent_sku = row["Parent SKU"]
       @luxire_stock.parent_sku = row["Variant SKU"]
      @luxire_stock.save!
      @luxire_product.luxire_stock_id = @luxire_stock.id
    end

    def associate_collection(row)
      # byebug
	    if ( !(row["Primary Usage"].casecmp(NOT_AVAILABLE) == 0) && !row["Primary Usage"].empty? )
          collections = row["Primary Usage"].split(",").map(&:strip)
          ids = []
          collections.each do |collection|
            collection_hierarchy = collection.split("->").map(&:strip)
            taxonomy_name = collection_hierarchy.first
            taxonomy = Spree::Taxonomy.where('lower(name) = ?', collection_hierarchy.first.downcase).first
            if taxonomy
               super_collection = false
               collection_hierarchy.delete(collection_hierarchy[0])
               collection_hierarchy.each_with_index do |hierarchy, count|
                  @taxon = taxonomy.taxons.where('lower(name) = ?', hierarchy.downcase).where(depth: count+1).first
                  unless @taxon
                    # info = collection_hierarchy[0]
                    # for i in 1..count
                    #   info+= "->"  + collection_hierarchy[i]
                    # end
                    # raise "#{taxonomy_name} -> #{info} collection does not exist"
                    super_collection = true
                    break;
                  end
               end
            else
              raise "#{collection} collection does not exist"
            end
            if collection_hierarchy.length == 0 || super_collection
              id = taxonomy.taxons.first.id
            else
              id = @taxon.id
            end
            ids << id
          end
          @product.taxon_ids = ids
          @product.save!
        else
            raise  "collection can not be empty or NA"
        end
    end

    def set_variant_sku(row)
     # byebug
      sku = row["Variant SKU"]
      variants = Spree::Variant.where("sku like ?","#{sku}%")
      # byebug
      if variants.empty?
        @variant[:sku] = sku
      else
        variants.each do |variant|
          product = variant.product
          product_type = product.luxire_product_type
          unless product_type.nil? || row["Type"].nil?
             type = product_type.product_type
             if type.casecmp(row["Type"]) == 0
               raise " duplicate product"
             end
          end
        end
        count = 1
        flag = true
        sku = sku + "p"
        while(flag)
          temp_sku = sku + count.to_s
          variant = Spree::Variant.where(sku: temp_sku).take
          if variant.nil?
            @variant[:sku] = temp_sku
            flag = false
          else
            count += 1;
          end
        end
      end
    end

    def populate_image(image)
      image_sources = image.split(",").map(&:strip)
      image_sources.each do |image_source|
        @image = Spree::Image.new
        @image.attachment= URI.parse(image_source)
        @image.viewable = @variant
        @image.save!
      end
    end

    def check_for_images(row)
      img_column = "Image Src"
      img_url = row[img_column]
      if (img_url.blank? || img_url.casecmp(NOT_AVAILABLE) == 0)
        for i in 1...7
          img_url = row["#{img_column}#{i}"]
          unless (img_url.blank? || img_url.casecmp(NOT_AVAILABLE) == 0)
            return
          end
        end
      else
        return
      end
      raise 'image can not be empty'
    end

#create the prices of uploaded product in all supported currency
    def populate_product_price_in_multi_currency
      currency = Currency.new
      currency.create_product_currency(@product_ids)
    end

    def send_error_list_to_admin
      p = Axlsx::Package.new
      sheet_path = "upload_reports/error_report_#{Time.now.to_i}.xlsx"
      p.workbook do |wb|
        wb.add_worksheet(:name => "Error report") do |sheet|
          sheet.add_row(["Index", "Record", "Exception"])
          count = 1
          @buggy_record.keys.each do |key|
            sheet.add_row([count, key, @buggy_record[key]])
            count += 1
          end
        end
      end
      p.serialize(sheet_path)
      # Send an email to admin with product upload status
      ProductUploadMailer.product_upload_status(@buggy_record, @count,sheet_path).deliver_now
    end

    def validate_record(row)
      EXPECTED_HEADER.each do |name|
        if row[name].nil? || row[name].blank?
          raise "Column #{name} can not be empty. Please insert a default value."
        end
      end
    end

    def validate_csv_format
      file = params[:file]
      headers = CSV.open(file.path, 'r') { |csv| csv.first }
      unless (headers - EXPECTED_HEADER).empty?
        removed_columns = EXPECTED_HEADER - headers
        added_columns = headers - EXPECTED_HEADER
        response = {msg: "You have added or removed columns"}
        response[:added_column] = added_columns unless added_columns.nil?
        response[:removed_columns] = removed_columns unless removed_columns.nil?
        render json: response.to_json, status: "422"
      end
    end

    def buggy_record_length
      @buggy_record.length > 0
    end
end
