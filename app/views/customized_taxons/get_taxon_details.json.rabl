object @taxonomy
attributes :name

child :taxons => :taxons do
attributes :id, :name
end

child @taxon => :child_taxons do
  attributes :id, :name
  child :products do
    extends "spree/api/products/taxon_show.v1.rabl"
  end
end
