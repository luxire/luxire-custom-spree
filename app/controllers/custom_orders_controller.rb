class CustomOrdersController < Spree::Api::BaseController

  def get_order
      guest_token = cookies.signed[:guest_token]
      @order = Spree::Order.where(guest_token: guest_token).where(completed_at: nil).last
      # render json: orders.to_json, status: "200"
      if @order.nil?
        response = {msg: "No in complete order exist"}
        render json: response.to_json, status: "404"
      else
       render "spree/api/orders/show.v1.rabl"
     end
  end

end
