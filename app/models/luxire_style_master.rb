class LuxireStyleMaster < ActiveRecord::Base
  has_many :luxire_product_type_style_masters, class_name: 'LuxireProductTypeStyleMaster'
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
#  has_many :luxire_product_types, class_name: "LuxireProductType", through: :luxire_product_type_style_masters
  has_many :luxire_products, class_name: 'LuxireProduct', through: :luxire_product_type
  has_many :products, class_name: 'Spree::Product', through: :luxire_products

  has_attached_file :image,  styles: { small: "64X64", medium: "128X128", large: "256X256" },
                             default_style: :small,
                             url: '/luxire/style_master/:id/:style/:basename.:extension',
                             path: ':rails_root/public/luxire/style_master/:id/:style/:basename.:extension',
                             convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

                             validates_attachment :image,
                                                content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

end
