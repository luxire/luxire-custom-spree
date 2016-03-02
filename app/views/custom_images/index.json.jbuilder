json.array!(@custom_images) do |custom_image|
  json.extract! custom_image, :id, :source
  json.url custom_image_url(custom_image, format: :json)
end
