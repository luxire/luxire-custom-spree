json.array!(@measurement_type_prototypes) do |measurement_type_prototype|
  json.extract! measurement_type_prototype, :id, :name, :value
  json.url measurement_type_prototype_url(measurement_type_prototype, format: :json)
end
