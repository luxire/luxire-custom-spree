object @taxonomy

if set = params[:set]
  extends "spree/api/taxonomies/#{set}"
else
  attributes *taxonomy_attributes
image_url = ENV['CDN'] + "luxire/images/taxons/"
  child :root => :root do |root|
      attributes *taxon_attributes
      node(:icon) {|i| "#{image_url}#{i.id}/normal/#{i.icon_file_name}" }

    child :children => :taxons do |taxon|
      attributes *taxon_attributes
      node(:icon) {|i| "#{image_url}#{i.id}/normal/#{i.icon_file_name}" }
    end
  end
end
