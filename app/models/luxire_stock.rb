class LuxireStock < ActiveRecord::Base
  has_many :luxire_products, class_name: "LuxireProduct"
  has_many :product, class_name: 'Spree::Product', through: :luxire_products
  belongs_to :stock_location, class_name: "Spree::StockLocation"

  validates :parent_sku, presence: true, uniqueness: {case_sensitive: true}

end
