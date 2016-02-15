json.array!(@luxire_product_type_style_masters) do |luxire_product_type_style_master|
  json.extract! luxire_product_type_style_master, :id, :luxire_product_type_id, :luxire_style_master_id
  json.url luxire_product_type_style_master_url(luxire_product_type_style_master, format: :json)
end
