object @taxon
attributes *taxon_attributes

node(:icon){ |t| t.icon unless t.icon.nil? || t.icon.url == "/assets/default_taxon.png" } 
node do |t|
  child t.children => :taxons do
    attributes *taxon_attributes
  end
end
node(:product_ids){ @product_ids }
