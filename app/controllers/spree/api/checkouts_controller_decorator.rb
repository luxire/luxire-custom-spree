Spree::Api::CheckoutsController.class_eval do
  # Validating whether the  gift card(if present) is applicable for each state
  # of the checkout flow.
  before_action :update_gift_code, only: :update, if: :gift_card_present

  helper Spree::Api::OrdersHelper

    # Check if the gift_card is present in params
    def gift_card_present
      # !params[:order][:gift_code].nil? && !params[:order][:gift_code].empty?
 	# guest_token = cookies.signed[:guest_token]
	# byebug
      @order = Spree::Order.where(number: params[:id]).where(completed_at: nil).last
      unless  @order.nil?
         gift_card = @order.adjustments.where(source_type: 'Spree::GiftCard').take
      else
	return false
      end
    end

    # Method apply_gift_code is used to apply gift card coupon
      def apply_gift_code
        guest_token = cookies.signed[:guest_token]
        @order = Spree::Order.where(guest_token: guest_token).where(completed_at: nil).last
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
          # Commenting the below two lines since we don't need a response if coupon code is applied
          # response={msg: 'Gift card is successfully applied', order: @order}
          # render json: response.to_json, status: '200'
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

# Update order adjustments based on the current_value of gift_card
    def update_gift_code
      gift_card_adjustments = @order.adjustments.where(source_type: 'Spree::GiftCard')
      gift_cards = Spree::GiftCard.find(gift_card_adjustments.pluck(:source_id))
      gift_cards.each do |gift_card|
        adjustment = @order.adjustments.where(source: gift_card).take
        adjustment.amount = gift_card.compute_amount(@order)
        adjustment.save!
        @order.update!
      end
    end


# Overided this method to make sure inventory is deducted once the order is placed.
    def update
      load_order(true)
      authorize! :update, @order, order_token

      if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
        if current_api_user.has_spree_role?('admin') && user_id.present?
          @order.associate_user!(Spree.user_class.find(user_id))
        end

        return if after_update_attributes

        if @order.completed? || @order.next
          state_callback(:after)
          # If order is completed reduce the inventory
          if @order.completed? && !@order.luxire_order.is_inventory_deducted
            @order.line_items.each do |line_item|
                product = line_item.product
                luxire_product_type = product.luxire_product_type
                stock = product.luxire_stock
                stock.virtual_count_on_hands -= luxire_product_type.length_required
                if(stock.threshold >= stock.virtual_count_on_hands)
                  # send an email
                  Spree::OrderMailer.send_mail_for_backorder(product).deliver_later
                end
                unless(stock.save)
                  response = { msg: " Unable to update order "}
                  render json: response.to_json, status: "422"
                  return
                end
              end
                  luxire_order = @order.luxire_order
                  luxire_order.is_inventory_deducted = true;
                  luxire_order.save!
          end
          respond_with(@order, default_template: 'spree/api/orders/show')
        else
          respond_with(@order, default_template: 'spree/api/orders/could_not_transition', status: 422)
        end
      else
        invalid_resource!(@order)
      end
    end

end
