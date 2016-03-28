class RetriveAttributeInfoController < ApplicationController

def get_customer_attr
  column_names = LuxireCustomer.column_names - ["id", "customer_created_by", "user_id", "created_at", "updated_at"]
  response = {msg: column_names}
  render json: response.to_json, status: "200"
end

def get_order_attr
column_names =   Spree::Order.column_names - ["id",  "user_id",  "bill_address_id", "ship_address_id", "shipping_method_id",  "created_at", "updated_at", "last_ip_address", "created_by_id","approver_id", "approved_at", "confirmation_delivered", "considered_risky", "guest_token",  "store_id", "state_lock_version"]
response = {msg: column_names}
render json: response.to_json, status: "200"
end

def get_shipping_attr
  column_names =  Spree::Shipment.column_names - ["id",  "order_id", "address_id",  "created_at", "updated_at", "stock_location_id"]
  response = {msg: column_names}
  render json: response.to_json, status: "200"
end

end
