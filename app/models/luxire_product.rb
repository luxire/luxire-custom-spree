class LuxireProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :luxire_vendor_master, class_name: 'LuxireVendorMaster'
  belongs_to :luxire_product_type, class_name: 'LuxireProductType'
  has_many :luxire_style_masters, class_name: "LuxireStyleMaster" , through: :luxire_product_type

  belongs_to :luxire_stock, class_name: "LuxireStock"
  has_many :standard_sizes, class_name: "StandardSize", through: :luxire_product_type
  attr_accessor :req_validation

  accepts_nested_attributes_for :luxire_stock
  validates :length_required, presence: true,numericality: true
  # validates_presence_of (LuxireProduct.column_names - ["id","created_at","updated_at", "deleted_at", "gift_card_flag", "luxire_product_type_id"]), :if => lambda { |product_type| product_type.req_validation.eql? true }
  # validates_inclusion_of :gift_card_flag, in: [true, false], :if => lambda { |product_type| product_type.req_validation.eql? true }
  # validates_presence_of :luxire_product_type_id
end
