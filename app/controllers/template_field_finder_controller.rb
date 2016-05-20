class TemplateFieldFinderController < ApplicationController

  def abandoned_checkouts
    response = {}
    object_array = []
    order_column_names = Spree::Order.column_names - ["created_at", "updated_at","id", "bill_address_id", "ship_address_id", "shipping_method_id","canceler_id", "store_id", "state_lock_version"]
    order_hash = {object_name: "@order", column_name: order_column_names}
    store_column_names = ["name"]
    store_hash = {object_name: "@store", column_name: store_column_names}
    line_item_column_names = Spree::LineItem.column_names - ["id", "variant_id", "order_id"]
    line_item_hash = {object_name: "@line_item", column_name: line_item_column_names}
    address_column_names = Spree::Address.column_names - ["id","created_at", "updated_at"]
    address_hash =  {object_name: "@address", column_name: address_column_names}
    object_array << order_hash
    object_array << store_hash
    object_array << line_item_hash
    object_array << address_hash
    response[:fields_detail] = object_array
    render json: response.to_json, status: "200"
  end

  def contact_customer
  end

  def customer_account_invite
  end

  def customer_account_welcome
  end

  def customer_account_password_reset
  end

  def draft_order_invoice
  end

  def fulfilment_request
  end

  def gift_cards_created
  end

  def new_order
  end

  def order_cancelled
  end

  def order_confirmation
  end

  def order_refund
  end

  def shipping_confirmation
  end

  def shipping_update
  end
end
