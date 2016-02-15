json.array!(@luxire_product_types) do |luxire_product_type|
  json.extract! luxire_product_type, :id, :product_type, :description
  json.url luxire_product_type_url(luxire_product_type, format: :json)
end
