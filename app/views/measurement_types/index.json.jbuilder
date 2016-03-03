json.array!(@measurement_types) do |measurement_type|
  json.extract! measurement_type, :id, :name, :description, :measurement_types, :image, :help, :help_url
  json.url measurement_type_url(measurement_type, format: :json)
end
