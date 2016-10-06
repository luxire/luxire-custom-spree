Spree::Gateway::BraintreeVzeroBase.class_eval do
private
  def token_params(provider, user, order)
      token_params = {}
      token_params[:customer_id] = user.id if braintree_user(provider, user, order)
      currency = order.try(:currency)
      merchant_account_id = currency ? get_merchant_account_id(currency) : nil
      token_params[:merchant_account_id] = merchant_account_id if merchant_account_id
      token_params
  end

  def get_merchant_account_id(currency)
      merchant_account_id = {EUR:"Luxire_EUR", AUD: "Luxire_AUD", SGD: "Luxire_SGD", NOK: "Luxire_NOK", DKK: "Luxire_DKK", SEK: "Luxire_SEK", CHF: "Luxire_CHF", INR: "Luxire_INR", GBP: "Luxire_GBP"}
      merchant_account_id[currency.to_sym]
  end
end
