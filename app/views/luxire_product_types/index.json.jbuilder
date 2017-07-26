image_url = ENV['CDN'] + "luxire/images/product_type/"
json.array!(@luxire_product_types) do |luxire_product_type|
   json.extract! luxire_product_type, :id, :product_type, :description
   unless luxire_product_type.image_file_name.nil? || luxire_product_type.image_file_name.blank?
     json.image  "#{image_url}#{luxire_product_type.id}/small/#{luxire_product_type.image_file_name}"
   else 
    json.image nil
   end
end
