class CustomOrdersController < ApplicationController

  def get_order
      guest_token = cookies.signed[:guest_token]
      orders = Spree::Order.where(guest_token: guest_token).where(completed_at: nil)
      render json: orders.first.to_json, status: "200"
  end

end
