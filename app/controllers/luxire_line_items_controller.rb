class LuxireLineItemsController < Spree::Api::BaseController
  before_action :authorize
  rescue_from Exception, with: :exception_handler
  helper Spree::Api::OrdersHelper

  def update
    luxire_line_items_data = params[:order][:luxire_line_items]
    LuxireLineItem.transaction do
      luxire_line_items_data.each do |luxire_line_item_data|
        luxire_line_item = LuxireLineItem.find(luxire_line_item_data.delete("id"))
        params[:luxire_line_item] = luxire_line_item_data
        luxire_line_item.update!(luxire_line_item_params)
      end
    end
    @order.update!
    render "spree/api/orders/show.v1.rabl"
  end

  def change_line_item_status
    fabric_states = ["Order received", "Order sheet generated", "Pattern Making", "Fabric cutting", "Tailoring", "Quality assurance", "Shipped", "Delivered"]
    pocket_square_states = ["Order received", "Make Printable Image", "Send for Printing", "Hand Rolling", "Quality assurance", "Shipped", "Delivered"]
    shoes_states = ["Order received", "Trial Pair", "Sent Trial Pair", "Analyze customer feedback", "Modify order", "Make Final Pair", "Quality assurance", "Shipped", "Delivered"]
    gift_card_states = ["Pending", "Scheduled for Fulfillment", "Fulfilled"]
    accessories_states = []
    additional_services_states = ["Merged with original order", "Pending", "Fulfilled"]
    #Array of product types for reference["Jackets", "Ties", "Belts", "Gift Cards", "Shirts", "Pants", "Pocket Squares"]
    #For Belts, Gift card and accessories states need to be determined
    product_type_states = {Shirts: fabric_states, Pants: fabric_states, Jackets: fabric_states,Vests: fabric_states,Ties: fabric_states,"Pocket Squares": pocket_square_states, Shoes: shoes_states,"Gift Cards": gift_card_states, "Additional Services": additional_services_states, Accessories: accessories_states }
    line_item = Spree::LineItem.find(params[:line_item_id])
    product = line_item.product
    luxire_product_type = product.luxire_product_type
    if luxire_product_type.nil?
      response = {msg: "Line item is not associated to any product type"}
      render json: response.to_json, status: "422"
      return
    end
    luxire_product_type = luxire_product_type.product_type
    states = product_type_states[luxire_product_type.to_sym]
    if states.nil?
      response = {msg: "States not defined for #{luxire_product_type}"}
      render json: response.to_json, status: "422"
      return
    end
    requested_states = params[:state]
    unless states.include? requested_states
      response = {msg: "Unknown state for #{luxire_product_type}"}
      render json: response.to_json, status: "422"
      return
    else
      luxire_line_item = line_item.luxire_line_item
      if luxire_line_item.fulfillment_status == requested_states
        response = {msg: "Line item already in #{requested_states} stage. Please send a new stage if you want to change the stage"}
        render json: response.to_json, status: "200" and return
      end
      luxire_line_item.fulfillment_status = requested_states
      if luxire_line_item.save
        response = {msg: "State changed successfully"}
        render json: response.to_json, status: "200"
      else
        response = {msg: "Error while #{luxire_line_item.errors.instance_variable_get(:@messages)}"}
        render json: response.to_json, status: "422"
      end
    end
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

   def luxire_line_item_params
#     params.require(:luxire_line_item).permit(:fulfillment_status, :line_item_id, :total_personalization_cost, :measurement_unit, :send_sample, :total_personalisation_cost_in_currencies,customized_data: {}, personalize_data: {}, measurement_data: {})
       params.require(:luxire_line_item).permit!
   end

end
