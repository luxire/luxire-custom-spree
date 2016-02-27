class LuxireProductDataImportsController < ApplicationController

    def import
      byebug
      file = params[:file]
      @count = 0
      @buggy_record = Hash.new
      CSV.foreach(file.path, headers: true, encoding: 'ISO-8859-1') do |row|
          @count += 1
          assign_values(row)
          begin
            Spree::Product.transaction do
             @product.save!
             @luxire_product[:product_id] = @product.id
             @variant[:product_id] = @product.id
             @variant[:is_master] = true
             @variant.save!
             if row["Image Src"]
               @image.viewable = @variant
               @image.save!
             end
             @luxire_product.save!
             set_up_options
            end
          rescue Exception => exception
             name = row["Handle"]
             @buggy_record[name] = exception.message
        end
      end
      logger.debug "Buggy record length is " + @buggy_record.length.to_s
      response = {count: @count, buggy_record: @buggy_record}
      render json: response.to_json, status: "200"
      # render 'luxire_product_data_imports/show.html.erb'
    end

    private
    def assign_values(row)

      @product = Spree::Product.new
      @luxire_product = LuxireProduct.new
      @option_arr = []
      @variant = Spree::Variant.new

      @product[:name] = row["Title"]
      @product[:description] = row["Body (HTML)"]

      @variant[:sku] = row["Variant SKU"]
      @variant[:weight] = row["Variant Grams"]
      @variant[:cost_price] = row["Variant Price"]

      # encoded_url = URI.encode(row["Variant Image"])
      if row["Image Src"]
        @image = Spree::Image.new
        @image.attachment= URI.parse(row["Image Src"])
      end

      option1  = row["Option1 Name"]
      value1 = row["Option1 Value"]
      option2 = row["Option2 Name"]
      value2  = row["Option2 Value"]
      option3  = row["Option3 Name"]
      value3  = row["Option3 Value"]

      @options_attrs = Hash.new(0)

      @options_attrs [option1.to_s] = value1  unless option1.nil?
      @options_attrs [option2.to_s] = value2  unless option2.nil?
      @options_attrs [option3.to_s] = value3  unless option3.nil?

      unless @options_attrs.empty?
        @option_arr << @options_attrs
      end

      @luxire_product[:handle] = row["Handle"]
      @luxire_product[:luxire_vendor_master_id] = row["Vendor"]
      @luxire_product[:luxire_product_type_id] = row["Type"]
      @luxire_product[:product_tags] = row["Tags"]  ||  @luxire_product[:search_tags] = row["Tags"]
      @luxire_product[:product_publish_date] = row["Published"] ||  @luxire_product[:product_publish_time] = row["Published"]
      # @luxire_product[:parent_sku] = row["Variant SKU"]
      # @luxire_product[:product_shipping_weight_unit] = row["Variant Grams"]
      @luxire_product[:inventory_tracker] = row["Variant Inventory Tracker"]
      @luxire_product[:product_inventory_policy] = row["Variant Inventory Policy"]
      @luxire_product[:product_fullfillment_service] = row["Variant Fulfillment Service"]
      # @luxire_product[:product_price] = row["Variant Price"]
      @luxire_product[:product_compare_at_price] = row["Variant Compare At Price"]
      @luxire_product[:product_requires_shipping] = row["Variant Requires Shipping"]
      @luxire_product[:product_charge_taxes_flag] = row["Variant Taxable"]
      @luxire_product[:product_barcode] = row["Variant Barcode"]
      # @luxire_product[:product_image_src] = row["Image Src"]
      @luxire_product[:product_img_alteration_text] = row["Image Alt Text"]
      @luxire_product[:gift_card_flag] = row["Gift Card"]
      @luxire_product[:global_upc] = row["Global / Upc"]
      @luxire_product[:google_shopping_MPN] = row["Google Shopping / MPN"]
      @luxire_product[:global_isbn] = row["Global / Isbn"]
      @luxire_product[:global_jan] = row["Global / Jan"]
      @luxire_product[:global_ean] = row["Global / Ean"]
      @luxire_product[:google_shopping_product_category] = row["Google Shopping / Google Product Category"]
      @luxire_product[:google_shopping_gender] = row["Google Shopping / Gender"]
      @luxire_product[:google_shopping_age_group] = row["Google Shopping / Age Group"]
      @luxire_product[:product_seo_page_title] = row["SEO Title"]
      @luxire_product[:product_seo_meta_description] = row["SEO Description"]
      @luxire_product[:google_shopping_adwords_grouping] = row["Google Shopping / AdWords Grouping"]
      @luxire_product[:google_shopping_adwords_labels] = row["Google Shopping / AdWords Labels"]
      @luxire_product[:google_shopping_condition] = row["Google Shopping / Condition"]
      @luxire_product[:google_shopping_custom_product] = row["Google Shopping / Custom Product"]
      @luxire_product[:google_shopping_custom_label0] = row["Google Shopping / Custom Label 0"]
      @luxire_product[:google_shopping_custom_label1] = row["Google Shopping / Custom Label 1"]
      @luxire_product[:google_shopping_custom_label2] = row["Google Shopping / Custom Label 2"]
      @luxire_product[:google_shopping_custom_label3] = row["Google Shopping / Custom Label 3"]
      @luxire_product[:google_shopping_custom_label4] = row["Google Shopping / Custom Label 4"]
      # @luxire_product[:product_image_src] = row["Variant Image"]
      @luxire_product[:product_shipping_weight_unit] = row["Variant Weight Unit"]

      # Luxire_stock[:virtual_count_on_hands], Luxire_stock[:physical_count_on_hands] = row["Variant Inventory Qty"]


    end

    def set_up_options
                @option_arr.each do |option|
                      option.each do |name,value|
                          option_type = Spree::OptionType.where(name: name).first_or_initialize do |option_type|
                            option_type.presentation = name
                            option_type.save!
                            end

                       optionValue = Spree::OptionValue.where(name: value).first_or_initialize do |optionValue|
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

end
