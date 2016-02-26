json.array!(@luxire_stocks) do |luxire_stock|
  json.extract! luxire_stock, :id, :stock_location_id, :parent_sku, :virtual_count_on_hands, :physical_count_on_hands, :measuring_unit, :backorderable, :deleted_at, :rack, :threshold, :product
  json.url luxire_stock_url(luxire_stock, format: :json)
end
