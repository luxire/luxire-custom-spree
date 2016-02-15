class ProductMeasurementType < ActiveRecord::Base
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
  belongs_to :measurement_type, class_name: "MeasurementType"
end
