class MeasurementType < ActiveRecord::Base
has_many :product_measurement_types, class_name: "ProductMeasurementType"
has_many :product_types, through: :product_measurement_type
has_attached_file :picture

validates :name, presence: true, uniqueness: true
end
