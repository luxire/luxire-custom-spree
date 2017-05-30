class CustomRefundController < Spree::Api::BaseController
  def refund
    authorize! :update, @order, params[:token]
    refund_amount = params[:refund_amount].to_f
    refund_reason_id = params[:refund_reason_id]
    order = Spree::Order.find_by(number: params[:order_number])
    gift_card_total = 0
    order.adjustments.where(source_type: "Spree::GiftCard").each do |adjustment|
	gift_card_total += adjustment.amount
    end
    total = order.payment_total + gift_card_total
    if(refund_amount > total)
      response = {msg: "Refund can not be greater than money paid"}
      render json: response.to_json, status: 422 and return
    end
   begin
    order.payments.each do |payment|
      transaction_id = payment.source.transaction_id
      if refund_amount <= payment.amount
	payment.source.refund(transaction_id, refund_amount, refund_reason_id, payment)
        refund_amount = 0
        break
      else
        payment.source.refund(transaction_id, payment.amount, refund_reason_id, payment)
        refund_amount -= payment.amount
        break if refund_amount == 0
      end
    end  
    if refund_amount > 0 && order.adjustments.where(source_type: "Spree::GiftCard").empty?
      order.adjustments.where(source_type: "Spree::GiftCard").each do |adjustment|
        gift_card = adjustment.source
        gift_card = gift_card.current_value + adjustment.amount
        gift_card.save!
        adjustment.amount = 0
        adjustment.save!
      end
    end
   rescue Exception => e
     response = {msg: "#{e.message}"}
     render json: response.to_json, status: 500 and return
   end
   order.update!
   response = {msg: 'Amount Refunded successfully'}
   render json: response.to_json, status: 200
  end
end
