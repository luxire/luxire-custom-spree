object @luxire_style_masters
attributes :id, :name, :default_values, :help, :description

child :image => :images do
  urls = ["small","medium","large"]
Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
    urls.each do |k|
      url_name = "#{k}_url"
      node(url_name) { |i| i.url(k) }
    end
  end
end

node(:real_images) { |i| real_images(i)}
node(:sketch_images) { |i| sketch_images(i)}
