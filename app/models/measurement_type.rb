class MeasurementType < ActiveRecord::Base
  has_many :product_measurement_types, class_name: "ProductMeasurementType"
  has_many :luxire_product_types, through: :product_measurement_types
  has_many :products, through: :luxire_product_types

  after_save :touch_products
  after_destroy :touch_products

  has_attached_file :image,  styles: { small: "64x64", medium: "128X128", large: "210X" },
                           default_style: :small,
                        url: '/luxire/images/measurement_type/:id/:style/:basename.:extension',
                        path: 'luxire/images/measurement_type/:id/:style/:basename.:extension',
                        convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

                        validates_attachment :image,
                                           content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

# Name can be used for standard and body measuement, so not neccessary to be unique.
# validates :name, presence: true, uniqueness: true
  validates :name, presence: true

  def touch_products
      products.update_all updated_at: Time.now
  end

end
