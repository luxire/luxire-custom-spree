class CustomBrainTreesController < ApplicationController
  def get_braintree_token
    order = Spree::Order.find_by_number(params[:order_number])
    if params[:order_token] == order.guest_token
      payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
      user = order.user
      token = payment_method.client_token(order, user)
      response = {token: token}
      render json: response.to_json, status: "200"
    else
      response = {msg: "You are not authorized to perform this action"}
      render json: response.to_json, status: "401"
    end
  end
end
