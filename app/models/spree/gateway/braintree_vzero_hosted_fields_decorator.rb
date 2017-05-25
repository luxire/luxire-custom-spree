Spree::Gateway::BraintreeVzeroHostedFields.class_eval do
  def cancel(transaction_id)
    provider
    transaction_detail = ::Braintree::Transaction.find(transaction_id)
    if(transaction_detail.status == 'submitted_for_settlement' || transaction_detail.status == 'authorized')
      cancelled_transaction = ::Braintree::Transaction.void(transaction_id)
    else
      cancelled_transaction =::Braintree::Transaction.refund(transaction_id)
    end
    @result = {success: true}
    unless(cancelled_transaction.class.to_s == "Braintree::SuccessfulResult")
      @result[:success] = false
      @result[:error] = cancelled_transaction.instance_variable_get(:@message)
    end
    handle_result(cancelled_transaction)
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
        authorization: response.instance_variable_get(:@transaction).id,
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

