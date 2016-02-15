class LuxireProductTypeStyleMaster < ActiveRecord::Base
  belongs_to :luxire_style_master, class_name: "LuxireStyleMaster"
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
end
