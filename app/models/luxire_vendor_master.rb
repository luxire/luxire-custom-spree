class LuxireVendorMaster < ActiveRecord::Base
  has_many :luxire_products, class_name: "LuxireProduct"
  has_many :products, class_name: 'Spree::Product', through: :luxire_products

  validates :name, presence: true, uniqueness: true
end
