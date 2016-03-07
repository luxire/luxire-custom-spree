class ReceiveEbsResponsesController < ApplicationController
respond_to :html, :json

INVALID_NUMBER = "Invalid number"
ERROR = "Error while saving data"
SUCCESS = "Data populated Successfully"

  def ebs_response
    number = params[:MerchantRefNo]
    # payment = Spree::Payment.find_by_number(number)
    order = Spree::Order.find_by_number(number)
    if order
    payment = order.payments.first
      if number && payment
      payment_method = payment.payment_method
      # order = payment.order
      response_code = params[:ResponseCode]
      response_msg = params[:ResponseMessage]
      date = DateTime.parse(params[:DateCreated])
          if(response_code == 0 && response_msg == "Transaction Successful")
              payment.response_code = params[:PaymentID]
              order.state = "complete"
              order.completed_at = date
              if(payment_method.auto_capture == true)
                payment.state = "completed"
                order.payment_total = params[:Amount]
                order.payment_state = "paid"
                order.transaction do
                  order.save
                  payment.save
                end
              else
                payment.state = "pending"
                order.payment_state ="balance_due"
                order.transaction do
                  order.save
                  payment.save
                end
              end
          else

          end
      else
        response = {msg: INVALID_NUMBER}
        render json: response.to_json, status: "422"
    end
  else
    response = {msg: "Order does not exist"}
    render json: response.to_json, status: "422"
    return
  end


  @order = order
  respond_with(@order, default_template: 'Spree::Api::Orders::show', status: 200)
end

end
