json.array!(@product_measurement_types) do |product_measurement_type|
  json.extract! product_measurement_type, :id, :luxire_product_type_id, :measurement_type_id
  json.url product_measurement_type_url(product_measurement_type, format: :json)
end
