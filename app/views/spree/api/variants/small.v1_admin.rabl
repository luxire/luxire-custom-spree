cache [I18n.locale, @current_user_roles.include?('admin'), 'small_variant', root_object]

# attributes *variant_attributes
# attributes :name, :price, :slug

node(:sku) { |p| p.sku }
# node(:is_backorderable) { |v| v.is_backorderable? }
# node(:total_on_hand) { |v| v.total_on_hand }



if root_object.images.empty?
  child( root_object.product.master.images => :images) { extends "spree/api/images/show" }
else
  child(:images => :images) { extends "spree/api/images/show" }
end
