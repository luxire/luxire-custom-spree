class LuxireStyleMaster < ActiveRecord::Base
  has_many :luxire_product_type_style_masters, class_name: 'LuxireProductTypeStyleMaster'
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
#  has_many :luxire_product_types, class_name: "LuxireProductType", through: :luxire_product_type_style_masters
  has_many :luxire_products, class_name: 'LuxireProduct', through: :luxire_product_type
  has_many :products, class_name: 'Spree::Product', through: :luxire_products
  has_many :luxire_style_master_images , class_name: "LuxireStyleMasterImage"
  validate :uniqueness_of_position

  has_attached_file :image,  styles: { small: "64X64", medium: "128X128", large: "256X256" },
                             default_style: :small,
                             url: '/luxire/images/style_master/:id/:style/:basename.:extension',
                             path: 'luxire/images/style_master/:id/:style/:basename.:extension',
                             convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

                             validates_attachment :image,
                                                content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  def uniqueness_of_position
    if position && luxire_product_type_id
      luxire_product_type = LuxireProductType.find(luxire_product_type_id)
      luxire_product_type_style_master = LuxireProductTypeStyleMaster.where(position: position,luxire_product_type_id: luxire_product_type_id).take
      unless luxire_product_type_style_master.nil?
          errors.add(:position, "Duplicate position for #{luxire_product_type.product_type}")
      end
    end
  end

end
