object @image
node(:id) {|image| image.id}
image_url = ENV['CDN'] + "luxire/images/products/"
Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
  url_name = "#{k}_url"
  # if (url_name.eql?"small_url") || (url_name.eql?"large_url")
    # node(url_name) { |i| i.attachment.url(k) }
    node(url_name) { |i| "#{image_url}#{i.id}/#{k}/#{i.attachment_file_name}" }
  # end
end
# node("original_url") { |i| i.attachment.url("original") }
node("original_url") { |i| "#{image_url}#{i.id}/original/#{i.attachment_file_name}" }
