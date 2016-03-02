json.array!(@standard_sizes) do |standard_size|
  json.extract! standard_size, :id, :fit_type, :neck, :chest, :waist, :bottom, :yoke, :biceps, :wrist, :shirt_length, :product_type_id
  json.url standard_size_url(standard_size, format: :json)
end
