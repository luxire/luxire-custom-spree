class ProductMeasurementType < ActiveRecord::Base
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
  belongs_to :measurement_type, class_name: "MeasurementType"
  validates :position, presence: true
  validates_uniqueness_of :position, :scope => :luxire_product_type_id
end
