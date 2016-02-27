module Spree
  class Gateway::Ebsin < Gateway

    def provider_class
    Spree::Gateway::Ebs
  end

  def method_type
    'ebs'
  end

  def purchase(amount, transaction_details, options = {})
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end

  end
end
