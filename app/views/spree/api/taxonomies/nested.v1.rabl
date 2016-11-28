attributes *taxonomy_attributes
image_url = ENV['CDN'] + "luxire/images/taxons/"
child :root => :root do
  attributes *taxon_attributes
  node(:icon) {|i| "#{image_url}#{i.id}/normal/#{i.icon_file_name}" }
  child :children => :taxons do
    attributes *taxon_attributes
    node(:icon) {|i| "#{image_url}#{i.id}/normal/#{i.icon_file_name}" }
    extends "spree/api/taxons/taxons"
  end
end
