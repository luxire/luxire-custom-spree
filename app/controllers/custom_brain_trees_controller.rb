class CustomBrainTreesController < ApplicationController
  before_action :check_luxire_inventory, only: :get_braintree_token

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

  private

  def check_luxire_inventory
    order = Spree::Order.find_by(number: params[:order_number])
    line_items = order.line_items
    return unless line_items
    line_items.each do |line_item|
      variant = Spree::Variant.find(line_item["variant_id"])
      product = variant.product
      length_required_per_product = product.luxire_product.length_required
      quantity = line_item["quantity"]
      stock = product.luxire_stock
      unless stock.backorderable
        total_length_required = length_required_per_product * quantity
        if(stock.virtual_count_on_hands - total_length_required < 0)
          response = {msg: "#{product.name} is out of stock. Please remove this item from cart to proceed."}
          render json: response.to_json, status: 422
        end
      end
    end
  end
end
