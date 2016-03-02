json.array!(@luxire_properties) do |luxire_property|
  json.extract! luxire_property, :id, :name, :value, :luxire_product_type_id
  json.url luxire_property_url(luxire_property, format: :json)
end
