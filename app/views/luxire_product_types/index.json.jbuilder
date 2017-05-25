image_url = ENV['CDN'] + "luxire/images/product_type/"
json.array!(@luxire_product_types) do |luxire_product_type|
   json.extract! luxire_product_type, :id, :product_type, :description
   json.image  "#{image_url}#{luxire_product_type.id}/small/#{luxire_product_type.image_file_name}"
end
