object @adjustment
cache [I18n.locale, root_object]
attributes *adjustment_attributes
node(:display_amount) { |a| a.display_amount.to_s }
node(:unit_price) do |a|
  if  a.adjustable.class.to_s == "Spree::Order"
      order = a.adjustable
      unit_price = a.amount
  else
      line_item = a.adjustable
      order = line_item.order
      unit_price = a.amount / line_item.quantity
  end
  display_unit_price = Spree::Money.new(unit_price, {currency: order.currency})
  display_unit_price.to_s
end
