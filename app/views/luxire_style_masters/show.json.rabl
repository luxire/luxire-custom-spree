object @luxire_style_master
attributes :id, :name, :default_values

child :luxire_product_type do 
attributes :id, :product_type, :description, :measurement_types

child :measurement_types do
attributes :id, :name, :value, :category, :sub_category
end
end
