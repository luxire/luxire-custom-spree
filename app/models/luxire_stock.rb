class LuxireStock < ActiveRecord::Base
  has_many :luxire_products, class_name: "LuxireProduct"
  has_many :products, class_name: 'Spree::Product', through: :luxire_products
  belongs_to :stock_location, class_name: "Spree::StockLocation"

  after_save :touch_products
  after_destroy :touch_products

  validates :parent_sku, presence: true, uniqueness: {case_sensitive: true}
  
  def touch_products
    products.update_all updated_at: Time.now
  end
end
