Spree::Promotion::Rules::ItemTotal.class_eval do
    preference :currency, :string, default: "USD"

    def eligible?(order, options = {})
      item_total = order.item_total
      byebug
      if order.currency == preferred_currency
        min = preferred_amount_min
        max = preferred_amount_max
      else
        currency = Currency.new
        min = currency.get_price_for_other_currency(preferred_amount_min.to_f,order.currency, preferred_currency)
        max = currency.get_price_for_other_currency(preferred_amount_max.to_f,order.currency, preferred_currency)
      end

      lower_limit_condition = item_total.send(preferred_operator_min == 'gte' ? :>= : :>, BigDecimal.new(min.to_s))
      upper_limit_condition = item_total.send(preferred_operator_max == 'lte' ? :<= : :<, BigDecimal.new(max.to_s))

      eligibility_errors.add(:base, ineligible_message_max) unless upper_limit_condition
      eligibility_errors.add(:base, ineligible_message_min) unless lower_limit_condition

      eligibility_errors.empty?
    end

end
