class LuxireVendorMaster < ActiveRecord::Base
  has_many :luxire_products, class_name: "LuxireProduct"
  has_many :products, class_name: 'Spree::Product', through: :luxire_products

  after_save :touch_products
  after_destroy :touch_products

  validates :name, presence: true, uniqueness: true

  def touch_products
    products.update_all updated_at: Time.now
  end
end
