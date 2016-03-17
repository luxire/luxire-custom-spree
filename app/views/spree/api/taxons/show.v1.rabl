object @taxon
attributes *taxon_attributes

node do |t|
  child t.children => :taxons do
    attributes *taxon_attributes
  end
end

child :products => :products do
  extends "spree/api/products/taxon_show"
end
