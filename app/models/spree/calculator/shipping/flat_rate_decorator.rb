Spree::Calculator::Shipping::FlatRate.class_eval do
  # preference :amount_if_less_than_order_total, :decimal, default: 0
  preference :order_total, :decimal, default: 49
  preference :amount_if_less_than_order_total, :decimal, default: 0

  def compute_package(package)
    order = package.order
    total = order.total
    # if order.currency == "USD"
    #   total = order.total
    # else
    #   total = Currency.last.get_price_for_other_currency(order.total, order.currency, "USD")
    # end
    if total >= preferences[:order_total]
      self.preferred_amount
    else
      preferences[:amount_if_less_than_order_total]
    end
  end

end
