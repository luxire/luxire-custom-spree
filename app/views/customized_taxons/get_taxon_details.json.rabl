object @taxonomy
  attributes :name
 node(:per_page) {params[:per_page]}
 node(:current_page) { params[:page] ? params[:page].to_i : 1 }
# node(:total_pages) {@products.num_pages}
child :taxons => :taxons do
  attributes :id, :name
end

child @products => :products do

  extends "spree/api/products/taxon_show.v1.rabl"
end
