class CreateLuxireProducts < ActiveRecord::Migration
  def change
    create_table :luxire_products do |t|
      t.string :handle
      t.string :product_tags
      t.float :product_compare_at_price
      t.string :parent_sku
      t.string :product_barcode
      t.string :product_visibility
      t.boolean :product_publish_flag
      t.string :product_publish_date
      t.string :product_publish_time
      t.boolean :product_charge_taxes_flag
      t.string :product_shipping_weight_unit
      t.boolean :product_can_oversell
      t.string :product_seo_page_title
      t.string :product_seo_meta_description
      t.string :product_seo_url
      t.string :product_color
      t.string :product_weave_type
      t.integer :thread_count
      t.string :material
      t.string :composition
      t.string :pattern
      t.string :transparency
      t.boolean :wrinkle_resistance
      t.string :thickness
      t.string :construction
      t.string :suitable_climates
      t.string :made_in
      t.string :search_tags
      t.string :inventory_tracker
      t.string :product_inventory_policy
      t.string :product_fullfillment_service
      t.boolean :product_requires_shipping
      t.boolean :product_charge_taxes_flag
      t.string :product_barcode
      t.string :product_image_src
      t.string :product_img_alteration_text
      t.boolean :gift_card_flag
      t.string :product_shipping_weight_unit
      t.integer :luxire_product_type_id
      t.integer :luxire_vendor_master_id
      t.string :google_shopping_product_category
      t.string :google_shopping_gender
      t.string :google_shopping_age_group
      t.string :google_shopping_MPN
      t.string :google_shopping_adwords_grouping
      t.string :google_shopping_adwords_labels
      t.string :google_shopping_condition
      t.string :google_shopping_custom_product
      t.string :google_shopping_custom_label0
      t.string :google_shopping_custom_label1
      t.string :google_shopping_custom_label2
      t.string :google_shopping_custom_label3
      t.string :google_shopping_custom_label4
      t.datetime :deleted_at
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
