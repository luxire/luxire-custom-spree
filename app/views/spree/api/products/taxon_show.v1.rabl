object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]


node(:id) { |p| p.id }
node(:name) { |p| p.name }
node(:display_price) { |p| p.display_price.to_s }
node(:slug) { |p| p.slug }

child :master => :master do
  extends "spree/api/variants/small"
end

child :variants => :variants do
  extends "spree/api/variants/small"
end

child :luxire_stock => :luxire_stock do
attributes :virtual_count_on_hands
end

child :luxire_product => :luxire_product do
attributes *LuxireProduct.column_names- ["created_at", "updated_at"]
end

child :luxire_vendor_master => :vendor_master do
attributes :name
end
