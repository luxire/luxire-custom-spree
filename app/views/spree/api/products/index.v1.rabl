#object @products
object false
node(:count) { @products.count }
node(:total_count) { @products.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @products.num_pages }

child(@products => :products) do


# child :products do
#   extends "spree/api/products/show.v2.rabl"
# end
node(:id) { |p| p.id }
node(:name) { |p| p.name }
node(:display_price) { |p| p.display_price }
node(:slug) { |p| p.slug }
node(:available_on) { |p| p.available_on }

child :master => :master do
#  attributes :images
  extends "spree/api/variants/small.v1.rabl"
end


child :variants => :variants do
  extends "spree/api/variants/small.v1.rabl"
end
child :luxire_stock => :luxire_stock do
  attributes  :virtual_count_on_hands
end
child :luxire_product => :luxire_product do
  attributes *LuxireProduct.column_names- ["created_at", "updated_at"]
end

child :luxire_vendor_master => :vendor_master do
  attributes :name
end
child :taxons => :taxons do
    attributes :name,:permalink
  end

end
