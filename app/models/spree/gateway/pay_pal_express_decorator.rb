Spree::Gateway::PayPalExpress.class_eval do
  def cancel(token)
    payment_source = Spree::PaypalExpressCheckout.where(token: token).last
    payment = Spree::Payment.find_by(source: payment_source)
    refund_transaction = refund(payment, payment.amount)
    @result = {success: true}
    unless refund_transaction.success?
      @result[:success] = false
      error_message = ""
      refund_transaction.Errors.each do |error|
       error_message += error.LongMessage
      end
      @result[:error] = error_message
    end
    handle_result(refund_transaction)
  end

  def message_from_result
    if @result[:success]
      "OK"
    else
     @result[:error]
    end
 end

  def build_results_hash(response)
    if @result[:success]
      {
        authorization: response.RefundTransactionID,
        avs_result: {
        }
      }
    else
      {}
    end
  end

  def handle_result(response)
    ActiveMerchant::Billing::Response.new(
      @result[:success],
      message_from_result,
      {},
      build_results_hash(response)
    )
  end

end

