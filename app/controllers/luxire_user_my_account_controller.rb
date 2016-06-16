class LuxireUserMyAccountController < Spree::Api::BaseController

  MULTIPLE_USER = "multiple user for same token is found"
  NO_USER = "no user found"
  NO_ORDER = "user has no order"


# Method index get all the orders for a specific customer which is not fulfilled
  def index
    get_users
    if(@users.length > 1)
    res = {msg: MULTIPLE_USER }
    render json: res.to_json, status: "422"
    elsif(@users.empty?)
      res = {msg: NO_USER}
      render json: res.to_json, status: "422"
    else
      @user = @users.first
      @luxire_orders = @user.luxire_orders.where("fulfillment_status != ? and fulfillment_status is not ?","Delivered", nil)
      unless @luxire_orders.nil?
        ids = @luxire_orders.pluck(:order_id)
        @orders = Spree::Order.find(ids)
      end
      # @orders = @user.orders.complete.order('completed_at desc')
      if(@orders.nil?)
        res = {msg: NO_ORDER}
        render json: res.to_json, status: "200"
      else
        render 'index.v1.rabl'
      end
    end
 end

# Method show get specific order for a specific customer
 def show
      @order = Spree::Order.find_by_number(params[:id])
      # @payment_methods = @order.payments.first.payment_method
      if(@order)
        render 'spree/api/orders/show.v1.rabl'
      else
        response = {msg: "No order exist"}
        render json: response.to_json, status: "200"
      end
 end

# Get previous order of customer which is already fulfilled
 def old_order
   get_users
   if(@users.length > 1)
   res = {msg: MULTIPLE_USER }
   render json: res.to_json, status: "422"
   elsif(@users.empty?)
     res = {msg: NO_USER}
     render json: res.to_json, status: "422"
   else
     @user = @users.first
     @luxire_orders = @user.luxire_orders.where(fulfillment_status: "Delivered")
     unless @luxire_orders.nil?
       ids = @luxire_orders.pluck(:order_id)
       @orders = Spree::Order.find(ids)
     end
     # @orders = @user.orders.complete.order('completed_at desc')
     if(@orders.nil?)
       res = {msg: NO_ORDER}
       render json: res.to_json, status: "200"
     else
       render 'index.v1.rabl'
     end
   end
 end

 # get_users get all the user based on token key
private
def get_users
  token = params[:token]
  @users = Spree::User.where(spree_api_key: token)
end

end
