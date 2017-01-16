object @line_item
cache [I18n.locale, root_object]
attributes *line_item_attributes
node(:single_display_amount) { |li| li.single_display_amount.to_s }
node(:display_total) { |li| li.formatted_total.to_s }
node(:total) { |li| li.total }
child :variant do
  extends "spree/api/variants/small"
  attributes :product_id, :sku
  if root_object.images.empty?
    child( root_object.product.master.images => :images) { extends "spree/api/images/show" }
  else
    child(:images => :images) { extends "spree/api/images/show" }
  end

end

child :adjustments => :adjustments do
  extends "spree/api/adjustments/show"
end

child :luxire_line_item do
  attributes *LuxireLineItem.column_names
end

node(:product_type){|li| li.product.luxire_product_type.product_type unless li.product.luxire_product_type.nil? }
