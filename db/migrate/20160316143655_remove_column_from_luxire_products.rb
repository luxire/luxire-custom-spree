class RemoveColumnFromLuxireProducts < ActiveRecord::Migration
  def change
  remove_column :luxire_products, :search_tags
   remove_column :luxire_products, :parent_sku
   remove_column :luxire_products,:product_publish_date
   rename_column :luxire_products, :pitch_sales, :sales_pitch
   remove_column :luxire_products, :product_image_src
  remove_column :luxire_products, :product_img_alteration_text
 remove_column :luxire_products, :global_upc
 remove_column :luxire_products, :google_shopping_MPN
 remove_column :luxire_products, :global_isbn
 remove_column :luxire_products, :global_jan
 remove_column :luxire_products, :global_ean
 remove_column :luxire_products, :google_shopping_product_category
 remove_column :luxire_products, :google_shopping_gender
 remove_column :luxire_products, :google_shopping_age_group
 remove_column :luxire_products, :product_seo_page_title
 remove_column :luxire_products, :product_seo_meta_description
 remove_column :luxire_products, :google_shopping_adwords_grouping
 remove_column :luxire_products, :google_shopping_adwords_labels
 remove_column :luxire_products, :google_shopping_condition
 remove_column :luxire_products, :google_shopping_custom_product
 remove_column :luxire_products, :google_shopping_custom_label0
 remove_column :luxire_products, :google_shopping_custom_label1
 remove_column :luxire_products, :google_shopping_custom_label2
 remove_column :luxire_products, :google_shopping_custom_label3
 remove_column :luxire_products, :google_shopping_custom_label4
 remove_column :luxire_products, :product_visibility
 remove_column :luxire_products, :product_publish_flag
 remove_column :luxire_products, :product_publish_time
 remove_column :luxire_products, :product_charge_taxes_flag
 remove_column :luxire_products, :product_shipping_weight_unit
 remove_column :luxire_products, :product_can_oversell
 remove_column :luxire_products, :product_seo_url
 remove_column :luxire_products, :material
 remove_column :luxire_products, :made_in
remove_column :luxire_products, :inventory_tracker
remove_column :luxire_products, :product_inventory_policy
remove_column :luxire_products, :product_fullfillment_service
remove_column :luxire_products, :product_requires_shipping


  end
end
