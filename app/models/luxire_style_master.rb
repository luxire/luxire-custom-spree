class LuxireStyleMaster < ActiveRecord::Base
  has_many :luxire_product_type_style_masters, class_name: 'LuxireProductTypeStyleMaster'
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
#  has_many :luxire_product_types, class_name: "LuxireProductType", through: :luxire_product_type_style_masters
  has_many :luxire_products, class_name: 'LuxireProduct', through: :luxire_product_type
  has_many :products, class_name: 'Spree::Product', through: :luxire_products
end
