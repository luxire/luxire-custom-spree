class CustomImage < ActiveRecord::Base
  attr_accessor :size

  has_attached_file :image,
  :styles => lambda { |a|  { :small => a.instance.size } },
                          default_style: :small,
                          url: '/luxire/images/custom_images/:id/:style/:basename.:extension',
                          path: 'luxire/images/custom_images/:id/:style/:basename.:extension',
                          convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

    validates_attachment :image,
                          content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

end
