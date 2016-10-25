object @luxire_style_masters
attributes :id, :name, :default_values, :help, :description

image_url = "https://cloudhop-subscriber-luxire-cdn.storage.googleapis.com/luxire/images/style_master/"
    node(:images) do |i|
    {small: "#{image_url}#{i.id}/small/#{i.image_file_name}", medium: "#{image_url}#{i.id}/medium/#{i.image_file_name}", large: "#{image_url}#{i.id}/large/#{i.image_file_name}"}
    end

node(:real_images) { |i| real_images(i)}
node(:sketch_images) { |i| sketch_images(i)}
