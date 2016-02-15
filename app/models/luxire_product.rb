class LuxireProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :luxire_vendor_master, class_name: 'LuxireVendorMaster'
  belongs_to :luxire_product_type, class_name: 'LuxireProductType'
  has_many :luxire_style_masters, class_name: "LuxireStyleMaster" , through: :luxire_product_type

  belongs_to :luxire_stock, class_name: "LuxireStock"
  validates :parent_sku, presence: true
  accepts_nested_attributes_for :luxire_stock
end
