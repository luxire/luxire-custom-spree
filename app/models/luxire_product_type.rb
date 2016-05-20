class LuxireProductType < ActiveRecord::Base
  has_many :luxire_products, class_name: 'LuxireProduct'
  #has_many :luxire_product_type_style_masters, class_name: 'LuxireProductTypeStyleMaster'
  has_many :luxire_style_masters, class_name: "LuxireStyleMaster", :dependent => :destroy
#  has_many :luxire_style_masters, class_name: "LuxireStyleMaster" , through: :luxire_product_type_style_masters
  has_many :products, class_name: 'Spree::Product', through: :luxire_products
  has_many :product_measurement_types, class_name: "ProductMeasurementType"
  has_many :measurement_types, through: :product_measurement_types
  has_many :standard_sizes, class_name: "StandardSize", :dependent => :destroy


   has_attached_file :image,  styles: { small: "128x128" },
                          default_style: :small,
                          url: '/luxire/product_type/:id/:style/:basename.:extension',
                          path: ':rails_root/public/luxire/product_type/:id/:style/:basename.:extension',
                          convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

  validates_attachment :image,
                     content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  validates :product_type, presence: true, uniqueness: true
  validates_presence_of :length_required

end
