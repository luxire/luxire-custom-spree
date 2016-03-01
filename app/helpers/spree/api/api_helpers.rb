module Spree
  module Api
    module ApiHelpers
      ATTRIBUTES = [
        :product_attributes,
        :product_property_attributes,
        :variant_attributes,
        :image_attributes,
        :option_value_attributes,
        :order_attributes,
        :line_item_attributes,
        :option_type_attributes,
        :payment_attributes,
        :payment_method_attributes,
        :shipment_attributes,
        :taxonomy_attributes,
        :taxon_attributes,
        :address_attributes,
        :country_attributes,
        :state_attributes,
        :adjustment_attributes,
        :inventory_unit_attributes,
        :return_authorization_attributes,
        :creditcard_attributes,
        :payment_source_attributes,
        :user_attributes,
        :property_attributes,
        :stock_location_attributes,
        :stock_movement_attributes,
        :stock_item_attributes,
        :promotion_attributes,
        :store_attributes,
        :addtional_product_attributes,
        :luxire_property_attributes,
	:luxire_line_item_attributes,
        :luxire_order_attributes,
	:luxire_product_attributes
      ]

      mattr_reader *ATTRIBUTES

      def required_fields_for(model)
        required_fields = model._validators.select do |field, validations|
          validations.any? { |v| v.is_a?(ActiveModel::Validations::PresenceValidator) }
        end.map(&:first) # get fields that are invalid
        # Permalinks presence is validated, but are really automatically generated
        # Therefore we shouldn't tell API clients that they MUST send one through
        required_fields.map!(&:to_s).delete("permalink")
        # Do not require slugs, either
        required_fields.delete("slug")
        required_fields
      end

      @@product_attributes = [
        :id, :name, :description,  :price, :display_price, :available_on,
        :slug, :meta_description, :meta_keywords, :shipping_category_id,
        :taxon_ids, :total_on_hand
      ]

      @@product_property_attributes = [
        :id, :property_name, :product_id, :property_id, :value, :property_presentation
      ]

      @@variant_attributes = [
        :id, :name, :sku, :price, :weight, :height, :width, :depth, :is_master,
        :slug, :description, :track_inventory
      ]

      @@image_attributes = [
        :id, :position, :attachment_content_type, :attachment_file_name, :type,
        :attachment_updated_at, :attachment_width, :attachment_height, :alt
      ]

      @@option_value_attributes = [
        :id, :name, :presentation, :option_type_name, :option_type_id,
        :option_type_presentation
      ]

      @@order_attributes = [
        :id, :number, :item_total, :total, :ship_total, :state, :adjustment_total,
        :user_id, :created_at, :updated_at, :completed_at, :payment_total,
        :shipment_state, :payment_state, :email, :special_instructions, :channel,
        :included_tax_total, :additional_tax_total, :display_included_tax_total,
        :display_additional_tax_total, :tax_total, :currency
      ]

      @@line_item_attributes = [:id, :quantity, :price, :variant_id]

      @@option_type_attributes = [:id, :name, :presentation, :position]

      @@payment_attributes = [
        :id, :source_type, :source_id, :amount, :display_amount,
        :payment_method_id, :response_code, :state, :avs_response, :number
      ]

      @@payment_method_attributes = [:id, :name, :description]

      @@shipment_attributes = [:id, :tracking, :number, :cost, :shipped_at, :state]

      @@taxonomy_attributes = [:id, :name]

      @@taxon_attributes = [
        :id, :name, :description, :products, :pretty_name, :permalink, :parent_id,
        :taxonomy_id, :icon
      ]

      @@inventory_unit_attributes = [
        :id, :lock_version, :state, :variant_id, :shipment_id,
        :return_authorization_id
      ]

      @@return_authorization_attributes = [
        :id, :number, :state, :order_id, :memo, :created_at, :updated_at
      ]

      @@address_attributes = [
        :id, :firstname, :lastname, :full_name, :address1, :address2, :city,
        :zipcode, :phone, :company, :alternative_phone, :country_id, :state_id,
        :state_name, :state_text
      ]

      @@country_attributes = [:id, :iso_name, :iso, :iso3, :name, :numcode]

      @@state_attributes = [:id, :name, :abbr, :country_id]

      @@adjustment_attributes = [
        :id, :source_type, :source_id, :adjustable_type, :adjustable_id,
        :originator_type, :originator_id, :amount, :label, :mandatory,
        :locked, :eligible,  :created_at, :updated_at
      ]

      @@creditcard_attributes = [
        :id, :month, :year, :cc_type, :last_digits, :name,
        :gateway_customer_profile_id, :gateway_payment_profile_id
      ]

      @@payment_source_attributes = [
        :id, :month, :year, :cc_type, :last_digits, :name
      ]

      @@user_attributes = [:id, :email, :created_at, :updated_at]

      @@property_attributes = [:id, :name, :presentation]

      @@stock_location_attributes = [
        :id, :name, :address1, :address2, :city, :state_id, :state_name,
        :country_id, :zipcode, :phone, :active
      ]

      @@stock_movement_attributes = [:id, :quantity, :stock_item_id]

      @@stock_item_attributes = [
        :id, :count_on_hand, :backorderable, :lock_version, :stock_location_id,
        :variant_id
      ]

      @@promotion_attributes = [
        :id, :name, :description, :expires_at, :starts_at, :type, :usage_limit,
        :match_policy, :code, :advertise, :path
      ]

      @@store_attributes = [
        :id, :name, :url, :meta_description, :meta_keywords, :seo_title,
        :mail_from_address, :default_currency, :code, :default
      ]

      @@addtional_product_attributes = [
          :id, :name, :description
      ]

       @@luxire_property_attributes = [
            :id, :name, :description
       ]

	@@luxire_line_item_attributes = [
              :fulfillment_status, :line_item_id
]

	@@luxire_order_attributes = [
  :fulfillment_status, :fulfilled_at, :fulfilled_at_zone, :accepts_marketing, :discount_code, :vendor, :order_id,
  :tags, :source, :tax1_name, :tax1_value, :tax2_name, :tax2_value, :tax3_name,
  :tax3_value, :tax4_name, :tax4_value, :tax5_name, :tax5_value, :customized_data,
  :personalize_data, :measurement_data, :notes_attributes
]

	@@luxire_property_attributes = [
            :id, :name, :description
       ]

	@@luxire_product_attributes = [

:id, :handle, :product_tags, :product_compare_at_price, :parent_sku, :product_barcode, :product_visibility, :product_publish_flag, :product_publish_date, :product_publish_time, :product_charge_taxes_flag, :product_shipping_weight_unit, :product_can_oversell, :product_seo_page_title, :product_seo_meta_description, :product_seo_url, :product_color, :product_weave_type, :thread_count, :material, :composition, :pattern, :transparency, :wrinkle_resistance, :thickness, :construction, :suitable_climates, :made_in, :search_tags, :inventory_tracker, :product_inventory_policy, :product_fullfillment_service, :product_requires_shipping, :product_image_src, :product_img_alteration_text, :gift_card_flag, :luxire_product_type_id, :luxire_vendor_master_id, :google_shopping_product_category, :google_shopping_gender, :google_shopping_age_group, :google_shopping_MPN, :google_shopping_adwords_grouping, :google_shopping_adwords_labels, :google_shopping_condition, :google_shopping_custom_product, :google_shopping_custom_label0, :google_shopping_custom_label1, :google_shopping_custom_label2, :google_shopping_custom_label3, :google_shopping_custom_label4, :deleted_at, :product_id, :created_at, :updated_at, :luxire_stock_id
	]



def variant_attributes
        if @current_user_roles && @current_user_roles.include?("admin")
          @@variant_attributes + [:cost_price]
        else
          @@variant_attributes
        end
      end
    end
  end
end
