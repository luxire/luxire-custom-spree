object @image
Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
  url_name = "#{k}_url"
  if (url_name.eql?"small_url") || (url_name.eql?"large_url")
    node(url_name) { |i| i.attachment.url(k) }
  end
end
