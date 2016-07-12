json.array!(@luxire_style_master_images) do |luxire_style_master_image|
  json.extract! luxire_style_master_image, :id, :category, :luxire_style_master_id, :alternate_text, :image
  json.url luxire_style_master_image_url(luxire_style_master_image, format: :json)
end
