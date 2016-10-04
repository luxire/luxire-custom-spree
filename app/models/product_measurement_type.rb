class ProductMeasurementType < ActiveRecord::Base
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
  belongs_to :measurement_type, class_name: "MeasurementType"
  # Commenting validation of position temporarily
  # validates_presence_of :measurement_type_id, :luxire_product_type_id, :position

  # validate :uniqueness_of_position
  validates_presence_of :measurement_type_id, :luxire_product_type_id
  def uniqueness_of_position
    if position && measurement_type_id && luxire_product_type_id
      measurement_type = MeasurementType.find(measurement_type_id)
      pmt = ProductMeasurementType.joins(:measurement_type).where("measurement_types.category = ? AND measurement_types.sub_category = ? AND product_measurement_types.position = ? AND product_measurement_types.luxire_product_type_id = ?", measurement_type.category, measurement_type.sub_category, position, luxire_product_type_id).take
      unless pmt.nil?
        unless measurement_type.sub_category.nil? || measurement_type.sub_category.blank?
          errors.add(:position, "Duplicate position for #{measurement_type.category} category and #{measurement_type.sub_category} sub_category of measurement_type id #{measurement_type.id}.")
        else
          errors.add(:position, "Duplicate position for #{measurement_type.category} category")
        end
      end
    end
  end
end
