Spree::Gateway::BraintreeVzeroBase::PurchaseData.class_eval do
	private
		def set_purchase_data(identifier_hash, order, money_in_cents, source)
          data = set_basic_purchase_data(identifier_hash, order, @utils, money_in_cents)
          merchant_account_id = get_merchant_account_id(order.currency)
          data.merge!(merchant_account_id: merchant_account_id) if merchant_account_id
          data.merge!(
            descriptor: { name: preferred_descriptor_name.to_s.gsub('/', '*') },
            options: {
              submit_for_settlement: auto_capture?,
              add_billing_address_to_payment_method: preferred_pass_billing_and_shipping_address ? true : false,
              three_d_secure: {
                required: (try(:preferred_3dsecure) unless source.admin_payment?)
              }
            }.merge!(@utils.payment_in_vault(data))
          )
          return data if source.admin_payment? || !preferred_advanced_fraud_tools
          data.merge!(device_data: source.advanced_fraud_data)
        end

        def get_merchant_account_id(currency)
            merchant_account_id = {EUR:"Luxire_EUR", AUD: "Luxire_AUD", SGD: "Luxire_SGD", NOK: "Luxire_NOK", DKK: "Luxire_DKK", SEK: "Luxire_SEK", CHF: "Luxire_CHF", INR: "Luxire_INR", GBP: "Luxire_GBP"}
            merchant_account_id[currency.to_sym]
        end
    end
