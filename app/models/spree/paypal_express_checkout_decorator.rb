Spree::PaypalExpressCheckout.class_eval do
 def refund(transaction_id, amount, refund_reason_id, payment)
    paypal = Spree::PaymentMethod.find_by(type: "Spree::Gateway::PayPalExpress")
    transaction = paypal.refund(payment, amount)
#    create_refund_record(amount, refund_reason_id, payment, transaction.RefundTransactionID)
#    Rails.logger.debug("transaction is #{transaction}")
#    create_refund_record(amount, refund_reason_id, payment, transaction.RefundTransactionID)
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
