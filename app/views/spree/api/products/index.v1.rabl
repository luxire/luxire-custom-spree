object @products

# child :products do
#   extends "spree/api/products/show.v2.rabl"
# end

node(:name) { |p| p.name }
node(:display_price) { |p| p.display_price }

child :master => :master do
  attributes :images
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
