class CustomOrdersController < Spree::Api::BaseController

  def get_order
      spree_api_token = request.headers["X-Spree-Token"] || params[:token]
       if spree_api_token.nil?
         guest_token = cookies.signed[:guest_token]
         @order = Spree::Order.where(guest_token: guest_token).where(completed_at: nil).where(user_id: nil).last
       else
         user = Spree::User.find_by_spree_api_key(spree_api_token)
         @previous_order = Spree::Order.where(user_id: user.id).where(completed_at: nil).offset(1).last
         @order = Spree::Order.where(user_id: user.id).where(completed_at: nil).last
          unless(@previous_order.nil? || @order.nil?)
  	        @previous_order.line_items.each do |line_item|
              line_item.order_id = @order.id
              line_item.save!
            end
            @previous_order.adjustments.each do |adjustment|
              adjustment.order_id = @order.id
              adjustment.save!
            end
            @previous_order.completed_at = Time.now
            @previous_order.user_id = nil
            @previous_order.save!
          end
       end
      # render json: orders.to_json, status: "200"
      if @order.nil?
        response = {msg: "No in complete order exist"}
        render json: response.to_json, status: "404"
      else
        @order.update! unless(@previous_order.nil?)
       render "spree/api/orders/show.v1.rabl"
     end
  end


  def change_order_status
    @order = Spree::Order.find(params[:order][:id])
    @luxire_order = @order.luxire_order
    @luxire_order.fulfillment_status = params[:order][:status]
    if @luxire_order.save
      response= {msg: "Order status changed successfully"}
      render json: response.to_json, status: "200"
    else
      response= {msg: "Error while saving order status"}
      render json: response.to_json, status: "422"
    end
  end
end
