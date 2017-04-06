object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]


 node(:id) { |p| p.id.to_s }

node(:name) { |p| p.name }
node(:price) { |p| p.price }
node(:display_price) { |p| p.display_price }
node(:slug) { |p| p.slug }
node(:description) { |p| p.description }
node(:available_on) { |p| p.available_on }

node(:is_gift_card) { |p| p.is_gift_card }
node(:shipping_category_id) { |p| p.shipping_category_id }
node(:taxon_ids) { |p| p.taxon_ids }



child :master => :master do
  attributes :id, :weight, :sku
  extends "spree/api/variants/small.v1_admin.rabl"

end

child :variants => :variants do
  attributes :sku, :price
  extends "spree/api/variants/small.v1_admin.rabl"
end

  child :luxire_stock => :luxire_stock do
    attributes  :parent_sku, :virtual_count_on_hands, :physical_count_on_hands, :rack, :thresold, :measuring_unit, :backorderable, :in_house, :fabric_width
  end

  child :luxire_product => :luxire_product do
    attributes *LuxireProduct.column_names - ["created_at", "updated_at"]
    # node(:product_type) do |luxire_product|
    #   luxire_product.luxire_product_type.product_type
    # end
  end

  child :luxire_vendor_master => :vendor_master do
    attributes :name
  end

  child :luxire_product_type => :product_type do
    attributes :id, :product_type
  end
