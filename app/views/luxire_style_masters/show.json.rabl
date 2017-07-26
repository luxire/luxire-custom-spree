object @luxire_style_master
attributes :id, :name, :default_values, :help, :description, :additional_cost

image_url = ENV['CDN'] + "luxire/images/style_master/"

node(:image) do |i|
 "#{image_url}#{i.id}/small/#{i.image_file_name}"
end

node(:images) do |i|
  {small: "#{image_url}#{i.id}/small/#{i.image_file_name}", medium: "#{image_url}#{i.id}/medium/#{i.image_file_name}", large: "#{image_url}#{i.id}/large/#{i.image_file_name}"}
end

# child :image => :images do
#    urls = ["small","medium","large"]
# #Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
# 	urls.each do |k|
# 		url_name = "#{k}_url"
# 		node(url_name) do |i|
#       i.url(k)
#     end
#   end
# end

node(:real_images) { |i| real_images(i)}
node(:sketch_images) { |i| sketch_images(i)}

child :luxire_product_type => :luxire_product_type do
 attributes :id, :product_type, :description, :measurement_types

 child :measurement_types => :measurement_types do
  attributes :id, :name, :value, :category, :sub_category
end

end
