class StandardSize < ActiveRecord::Base
  belongs_to :luxire_product_type, class_name: "LuxireProductType"
end
