Spree::Calculator::FlatRate.class_eval do
  def compute(object=nil)
    byebug
    if object && preferred_currency.upcase == object.currency.upcase
      preferred_amount
    else
    Currency.new.get_price_for_other_currency(preferred_amount, preferred_currency.upcase, object.currency.upcase)
    end
  end
end
