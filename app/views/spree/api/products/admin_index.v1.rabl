# object @products
object false
node(:count) { @products.count }
node(:total_count) { @products.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @products.num_pages }




child(@products => :products) do

  node(:id) { |p| p.id.to_s }
  node(:name) { |p| p.name}
  node(:is_gift_card) { |p| p.is_gift_card }

child :master => :master do
  attributes :id
  extends "spree/api/variants/small.v1_admin.rabl"
end


child :variants => :variants do
  attributes :id, :sku, :images
  extends "spree/api/variants/small.v1_admin.rabl"
end

child :luxire_stock => :luxire_stock do
  attributes  :id, :stock_location_id, :rack, :threshold
end

child :luxire_product => :luxire_product do
  attributes :id, :luxire_product_type_id, :luxire_vendor_master_id, :product_id, :luxire_stock_id
end

child :luxire_product_type => :product_type do
  attributes :product_type
end

child :luxire_vendor_master => :vendor_master do
  attributes :name
end
end
