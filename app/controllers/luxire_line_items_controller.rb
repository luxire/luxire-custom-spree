class LuxireLineItemsController < ApplicationController
  before_action :authorize
  rescue_from Exception, with: :exception_handler

  def update
    luxire_line_items = params[:order][:luxire_line_items]
    LuxireLineItem.transaction do
      luxire_line_items.each do |params|
        luxire_line_item = LuxireLineItem.find(params.delete("id"))
        luxire_line_item.update!(params)
      end
    end
    order.update!
    render "spree/api/orders/show.v1.rabl"
  end

  private
   def authorize
    @order = Spree::Order.find_by_number(params[:order][:number])
    unless @order.guest_token == params[:order][:token]
      response = {msg: "You are not authorized to perform this action"}
      render json: response.to_json, status: "422"
    end
   end

   def exception_handler(exception)
     response = {msg: "Exception while updating luxire line items and the reason is #{exception.message}"}
     render json: response.to_json, status: "422"
   end
end
