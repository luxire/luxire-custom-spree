class LuxireProductTypeStyleMaster < ActiveRecord::Base
  belongs_to :luxire_style_master, class_name: "LuxireStyleMaster"
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
  belongs_to :user, class_name: "Spree::User"
  validates_presence_of :position
  validate :uniqueness_of_position
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
