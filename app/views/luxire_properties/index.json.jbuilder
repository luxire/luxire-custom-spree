json.array!(@luxire_properties) do |luxire_property|
  json.extract! luxire_property, :id, :name, :value
  json.url luxire_property_url(luxire_property, format: :json)
end
