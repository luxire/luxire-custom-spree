class LuxireProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :luxire_vendor_master, class_name: 'LuxireVendorMaster'
  belongs_to :luxire_product_type, class_name: 'LuxireProductType'
  has_many :luxire_style_masters, class_name: "LuxireStyleMaster" , through: :luxire_product_type

  belongs_to :luxire_stock, class_name: "LuxireStock"
  has_many :luxire_properties, class_name: "LuxireProperty", through: :luxire_product_type
  has_many :standard_sizes, class_name: "StandardSize", through: :luxire_product_type

  validates :parent_sku, presence: true
  accepts_nested_attributes_for :luxire_stock
  # validates_presence_of (LuxireProduct.column_names - ["id","created_at","updated_at"])
end
