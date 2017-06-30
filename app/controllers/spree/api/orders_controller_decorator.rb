Spree::Api::OrdersController.class_eval do
  skip_before_action :find_order, only: :apply_gift_code
  before_action :check_luxire_inventory, only: :create

  def create
    # byebug
    authorize! :create, Spree::Order
    order_user = if @current_user_roles.include?('admin') && order_params[:user_id]
      Spree.user_class.find(order_params[:user_id])
    else
      current_api_user
    end

    import_params = if @current_user_roles.include?("admin")
      params[:order].present? ? params[:order].permit! : {}
    else
      order_params
    end

    @order = Spree::Core::Importer::Order.import(order_user, import_params, cookies.signed[:guest_token])
    LuxireOrder.create!(order_id: @order.id)
    respond_with(@order, default_template: :show, status: 201)
  end


  # Method apply_gift_code is used to apply gift card coupon
    def apply_gift_code
#	byebug
 #     guest_token = cookies.signed[:guest_token]
  #    @order = Spree::Order.where(guest_token: guest_token).where(completed_at: nil).last
    @order = Spree::Order.where(number: params[:order][:number]).where(completed_at: nil).last
      if !@order.nil? && params[:order][:gift_code]
        @order.gift_code = params[:order][:gift_code]
        # @order.coupon_code = params[:order][:gift_code]
      else
        response={msg: 'Gift card code is missing or the order is empty'}
        render json: response.to_json, status: '422'
        return
      end
      if gift_card = Spree::GiftCard.find_by_code(@order.gift_code) and gift_card.order_activatable?(@order)
        gift_card.apply(@order)
        response={msg: 'Gift card is successfully applied', order: @order}
        render json: response.to_json, status: '200'
      else
        gift_card = Spree::GiftCard.find_by_code(@order.gift_code)
        response={msg: 'Gift card cannot be applied'}
        if gift_card.nil?
        response[:reason] = "Invalid Gift Card"
        else
          response[:reason] = gift_card.find_reason(@order)
        end
        render json: response.to_json, status: '422'
      end
  end


private

  def order_params
    if params[:order]
      normalize_params
      # # Getting all the column names of LuxireLineItem and converting it into symbol
      # luxire_line_items = LuxireLineItem.column_names
      # luxire_line_items -= ["created_at", "updated_at"]
      # # Get all the permitted_order_attributes and convert it to string and assign it to modified_permitted_order_attributes
      # # so that manipulating the value will not have any impact on permitted_order_attributes
      # modified_permitted_order_attributes = permitted_order_attributes.each { |x| x.to_s}
      # # Create luxire_line_items_hash. Add this hash to line_items array
      # luxire_line_items_hash = { "luxire_line_item_attributes": luxire_line_items }
      # # Get the line_items and delete it from the root array
      # line_items = permitted_order_attributes.last
      # modified_line_items = modified_permitted_order_attributes.pop
      # byebug
      # # Adding the hash to line_items array
      # modified_line_items[:line_items_attributes].push(luxire_line_items_hash)
      # # Adding th array back to modified_permitted_order_attributes
      # modified_permitted_order_attributes << modified_line_items
      # # Replace the last item of permitted_order_attributes with the previous value.
      # # The last value of permitted_order_attributes has changed since we have used
      # # :line_items_attributes symbol
      # permitted_order_attributes.pop
      # permitted_order_attributes << line_items
      # byebug
      # params.require(:order).permit(modified_permitted_order_attributes)
      params.require(:order).permit!
    else
      {}
    end
  end

    def check_luxire_inventory
      line_items = params[:order][:line_items]
      return unless line_items
      line_items.each do |line_item|
        variant = Spree::Variant.find(line_item["variant_id"])
        product = variant.product
        length_required_per_product = product.luxire_product.length_required
        quantity = line_item["quantity"]
        stock = product.luxire_stock
        unless stock.backorderable
          total_length_required = length_required_per_product * quantity
          if(stock.virtual_count_on_hands - total_length_required < 0)
            response = {msg: "#{product.name} is out of stock"}
            render json: response.to_json, status: 422
          end
        end
      end
    end
end
