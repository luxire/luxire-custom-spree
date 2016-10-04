class LuxireLineItemsController < ApplicationController
  before_action :authorize
  rescue_from Exception, with: :exception_handler

  def update
    luxire_line_items = params[:order][:luxire_line_items]
    luxire_line_items.each do |luxire_line_item|
      luxire_line_item.update!
    end
    order.update!
    render "spree/api/orders/show.v1.rabl"
  end

  private
   def authorize
    @order = Spree::Order.find_by_number(params[:order][:number])
    unless @order.token == params[:order][:token]
      response = {msg: "You are not authorized to perform this action"}
      render json: response.to_json, status: "422"
    end
   end

   def exception_handler(exception)
     response = {msg: "Exception while updating luxire line items and the reason is #{exception.message}"}
     render json: response.to_json, status: "422"
   end
end
