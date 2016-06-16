object @luxire_style_masters
attributes :id, :name, :default_values, :help

child :image => :images do
urls = ["small","medium","large"]
#Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
  urls.each do |k|
  url_name = "#{k}_url"
  node(url_name) { |i| i.url(k) }
end
end
