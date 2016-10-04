class LuxireLineItemsController < Spree::Api::BaseController
  before_action :authorize
  rescue_from Exception, with: :exception_handler
  helper Spree::Api::OrdersHelper

  def update
    luxire_line_items = params[:order][:luxire_line_items]
    LuxireLineItem.transaction do
      luxire_line_items.each do |params|
        luxire_line_item = LuxireLineItem.find(params.delete("id"))
        luxire_line_item.update!(luxire_line_item_params(params))
      end
    end
    @order.update!
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

   def luxire_line_item_params(params)
     ActionController::Parameters.new({luxire_line_item: params}).require(:luxire_line_item).permit(:fulfillment_status, :line_item_id, :customized_data, :personalize_data, :measurement_data, :total_personalization_cost, :measurement_unit, :send_sample, :total_personalisation_cost_in_currencies)
   end

end
