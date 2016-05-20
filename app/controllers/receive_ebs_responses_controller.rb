class ReceiveEbsResponsesController < ApplicationController
respond_to :html, :json
rescue_from Exception, with: exception_handler

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
                  order.save!
                  payment.save!
                  if order.luxire_product.is_inventory_deducted
                      order.line_items.each do |line_item|
                        product = line_item.product
                        luxire_product = product.luxire_product
                        stock = luxire_product.luxire_stock
                        stock.virtual_count_on_hands -= luxire_product.length_required
                        if(stock.threshold >= stock.virtual_count_on_hands)
                          # send an email
                          Spree::OrderMailer.send_mail_for_backorder(product).deliver_later
                        end
                        stock.save!
                  end
                  luxire_order = order.luxire_order
                  luxire_order.is_inventory_deducted = true;
                  luxire_order.save!
                end
              end
                if(@exp)
                  response = {msg: "Exception raised during updating records"}
                  render json: response.to_json, status: "422"
                  return
                end
              end
          else
              log = Spree::LogEntry.new
              log.source = payment
              log.details =
              payment.state = "failed"
              payment.response_code = params[:PaymentID]
              payment.transaction do
                log.save!
                payment.save!
              end
              if(@exp)
                response = {msg: "Exception raised during updating records"}
                render json: response.to_json, status: "422"
                return
              end
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

def exception_handler
  @exp = true;
end


end
