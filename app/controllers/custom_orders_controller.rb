class CustomOrdersController < Spree::Api::BaseController

  helper Spree::Api::OrdersHelper

    def recent_completed_orders
      authorize! :index, Spree::Order
      @orders = Spree::Order.where("spree_orders.completed_at IS NOT NULL").order("completed_at desc").page(params[:page]).per(params[:per_page])
      render 'spree/api/orders/index.v1.rabl'
    end
  

   def get_order
      spree_api_token = request.headers["X-Spree-Token"] || params[:token]
       if spree_api_token.nil? || spree_api_token.empty?
         guest_token = cookies.signed[:guest_token]
         @order = Spree::Order.where(guest_token: guest_token,completed_at: nil,user_id: nil).last
       else
        user = Spree::User.find_by_spree_api_key(spree_api_token)

	@previous_order = Spree::Order.where("user_id = ? and completed_at is ? and state != ?",user.id, nil, "complete").offset(1).last
	@order = Spree::Order.where("user_id = ? and completed_at is ? and state != ?",user.id, nil, "complete").last


          unless(@previous_order.nil? || @order.nil? || @order.state != "cart")
            if @previous_order.currency != @order.currency
               @previous_order = Currency.new.update_order_currency(@previous_order, @order.currency)
               @previous_order.save!
            end

            @previous_order.line_items.each do |line_item|
              line_item.order_id = @order.id
              line_item.save!
            end
=begin
            @previous_order.adjustments.each do |adjustment|
              adjustment.order_id = @order.id
              adjustment.save!
            end
=end
            @previous_order.completed_at = Time.now
            @previous_order.user_id = nil
            @previous_order.save!
          end
       end
      # render json: orders.to_json, status: "200"
      if @order.nil?
        response = {msg: "No incomplete order exist"}
        render json: response.to_json, status: "404"
      else
        @order.update! unless(@previous_order.nil?)
       render "spree/api/orders/show.v1.rabl"
     end
  end


  def change_order_status
    states = ["Order received" ,"Order sheet generated", "Processing", "Shipped", "Delivered"]
    @order = Spree::Order.find(params[:order][:id])
    @luxire_order = @order.luxire_order
    unless(states.include? params[:order][:status])
      response= {msg: "Unknown status"}
      render json: response.to_json, status: "422"
      return;
    end
    current_status = @luxire_order.fulfillment_status
    requested_status = params[:order][:status]
    if current_status.nil?
      if requested_status== "Order sheet generated"
        @luxire_order.fulfillment_status = requested_status
	@luxire_order.status_changed_time = Time.current
      else
        response= {msg: "Can't go to #{requested_status} directly"}
        render json: response.to_json, status: "422"
	return
      end
    else
      if(states.find_index(requested_status) == (states.find_index(current_status) + 1))
        @luxire_order.fulfillment_status = requested_status
	#@luxire_order.status_changed_time = Time.current
      elsif(states.find_index(requested_status) == states.find_index(current_status))
        response= {msg: "Current and requested status is same"}
        render json: response.to_json, status: "422"
        return
      elsif (states.find_index(requested_status) < states.find_index(current_status))
        response= {msg: "Can't go to #{requested_status} from #{current_status} state"}
        render json: response.to_json, status: "422"
        return
      elsif (states.find_index(requested_status) > (states.find_index(current_status) + 1))
        response= {msg: "Can't go to #{requested_status} directly from #{current_status} state"}
        render json: response.to_json, status: "422"
	return
      end
    end

    if @luxire_order.save
      response= {msg: "Order status changed successfully"}
      render json: response.to_json, status: "200"
    else
      response= {msg: "Error while saving order status"}
      render json: response.to_json, status: "422"
    end
  end
end
