class LuxireStyleMasterImage < ActiveRecord::Base
  belongs_to :luxire_style_master, class_name: "LuxireStyleMaster"
  has_many :products, through: :luxire_style_master

  after_save :touch_products
  after_destroy :touch_products

  has_attached_file :image,  styles: { small: "64X64", medium: "128X128", large: "256X256" },
                             default_style: :small,
                             url: '/luxire/images/style_master_images/:id/:style/:basename.:extension',
                             path: 'luxire/images/style_master_images/:id/:style/:basename.:extension',
                             convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

                             validates_attachment :image,
                                                content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

 def touch_products
    products.update_all updated_at: Time.now
 end
end
