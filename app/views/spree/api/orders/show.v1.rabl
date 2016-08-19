
object @order
extends "spree/api/orders/order"

if lookup_context.find_all("spree/api/orders/#{root_object.state}").present?
  extends "spree/api/orders/#{root_object.state}"
end

child :billing_address => :bill_address do
  extends "spree/api/addresses/show"
end

child :shipping_address => :ship_address do
  extends "spree/api/addresses/show"
end

child :luxire_order => :luxire_order do
  attributes *luxire_order_attributes
end

child :line_items => :line_items do
  extends "spree/api/line_items/show"
  child :variant do
    attributes :sku
  end
  child :luxire_line_item => :luxire_line_item do
    attributes *luxire_line_item_attributes
  end
  # if @current_user_roles.include?('admin')
    child :luxire_stock do
      attributes :rack
    end
  # end
end

child :payments => :payments do
  attributes *payment_attributes

  child :payment_method => :payment_method do
    attributes :id, :name
  end
child :source => :source do
    if @current_user_roles.include?('admin')
      attributes *payment_source_attributes + [:gateway_customer_profile_id, :gateway_payment_profile_id]
    else
      attributes *payment_source_attributes
    end
  end
end

child :shipments => :shipments do
  extends "spree/api/shipments/small"
end

child :adjustments => :adjustments do
  extends "spree/api/adjustments/show"
end


# Necessary for backend's order interface
node :permissions do
  { can_update: current_ability.can?(:update, root_object) }
end

child :valid_credit_cards => :credit_cards do
  extends "spree/api/credit_cards/show"
end

child :luxire_order => :luxire_order do
attributes :fulfillment_status, 
end

node(:product_types) {|order| get_product_type_details(order)}
