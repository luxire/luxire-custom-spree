Spree::BraintreeCheckout.class_eval do
  def refund(transaction_id, amount, refund_reason_id, payment)
    Spree::PaymentMethod.find_by(type: "Spree::Gateway::BraintreeVzeroHostedFields").provider
    refund_transaction = ::Braintree::Transaction.refund(transaction_id, amount)  
    if refund_transaction.class.to_s == "Braintree::SuccessfulResult"
       create_refund_record(amount, refund_reason_id, payment, refund_transaction.instance_variable_get(:@transaction).id)
    else
       raise "#{refund_transaction.instance_variable_get(:@message)}"
    end
  end

  def create_refund_record(amount, refund_reason_id, payment, transaction_id)
      refund = Spree::Refund.new
      refund.payment_id = payment.id
      refund.amount = amount
      refund.refund_reason_id = refund_reason_id 
      refund.transaction_id = transaction_id
      refund.save!
  end
end
