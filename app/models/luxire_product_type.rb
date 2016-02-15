class LuxireProductType < ActiveRecord::Base
  has_many :luxire_products, class_name: 'LuxireProduct'
  #has_many :luxire_product_type_style_masters, class_name: 'LuxireProductTypeStyleMaster'
  has_many :luxire_style_masters, class_name: "LuxireStyleMaster"
#  has_many :luxire_style_masters, class_name: "LuxireStyleMaster" , through: :luxire_product_type_style_masters
  has_many :products, class_name: 'Spree::Product', through: :luxire_products
  has_many :product_measurement_types, class_name: "ProductMeasurementType"
  has_many :measurement_types, through: :product_measurement_types

  validates :product_type, presence: true, uniqueness: true

end
