class MeasurementType < ActiveRecord::Base
has_many :product_measurement_types, class_name: "ProductMeasurementType"
has_many :product_types, through: :product_measurement_type
has_attached_file :image,  styles: { small: "64x64", medium: "128X128" },
                           default_style: :small,
                        url: '/luxire/measurement_type/:id/:style/:basename.:extension',
                        path: ':rails_root/public/luxire/measurement_type/:id/:style/:basename.:extension',
                        convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

                        validates_attachment :image,
                                           content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

validates :name, presence: true, uniqueness: true
end
