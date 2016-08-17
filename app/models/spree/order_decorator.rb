Spree::Order.class_eval do
has_one :luxire_order, class_name: "LuxireOrder", dependent: :destroy
has_many :luxire_line_items, class_name: 'LuxireLineItem', through: :line_items
# accepts_nested_attributes_for :luxire_order

# Finalizes an in progress order after checkout is complete.
# Called after transition to complete state when payments will have been processed.
def finalize_with_gift_card!
  # finalize_without_gift_card!
  # Record any gift card redemptions.
  self.adjustments.where(source_type: 'Spree::GiftCard').each do |adjustment|
    gift_card = adjustment.source
    amount = adjustment.amount
    unless gift_card.line_item.currency == self.currency
      amount = Currency.new.get_price_for_other_currency(amount, self.currency, gift_card.line_item.currency)
    end
    adjustment.source.debit(amount, self)
  end
end

def finalize!
  # lock all adjustments (coupon promotions, etc.)
  all_adjustments.each{|a| a.close}

  # update payment and shipment(s) states, and save
  updater.update_payment_state
  shipments.each do |shipment|
    shipment.update!(self)
    shipment.finalize!
  end

  updater.update_shipment_state
  save!
  updater.run_hooks

  touch :completed_at

# rescue from Exception in case internet is down and will not be able to send email
  begin
      deliver_gift_card_email unless confirmation_delivered?
      deliver_order_confirmation_email unless confirmation_delivered?
  rescue Exception => e
      logger.error "Exception while sending the email #{e.message}"
  end
  finalize_with_gift_card!
  reduce_inventory
  consider_risk

end

  def reduce_inventory
    if luxire_order.is_inventory_deducted
         line_items.each do |line_item|
            product = line_item.product
            luxire_product_type = product.luxire_product_type
            stock = product.luxire_stock
            stock.virtual_count_on_hands -= luxire_product_type.length_required
            if(stock.threshold >= stock.virtual_count_on_hands)
              # send an email
              Spree::OrderMailer.send_mail_for_backorder(product).deliver_later
            end
            begin
              stock.save!
            rescue Exception => e
              logger.error "Exception while updating stock #{e.message}"
              return
            end
          end
          luxire_order.is_inventory_deducted = true;
          luxire_order.save!
    end
  end

  def deliver_gift_card_email
    # Added to Spree functionality
    # Send an email containing the gift_card coupon code if the product is a gift_card
      if self.paid?
        line_items = self.line_items
        line_items.each do |line_item|
          line_item.quantity.times do
            if  line_item.product.is_gift_card
              @line_item = line_item
              @gift_card = Spree::GiftCard.new
              @gift_card.variant_id = @line_item.variant_id
              @gift_card.line_item_id = @line_item.id
              @gift_card.current_value = @line_item.cost_price
              @gift_card.original_value = @line_item.cost_price
              @gift_card.email = self.email
              # Add 2 years to the current date and set the expiry date to the same.
              # 2*365*24*60*60 represents 2 years in seconds as you can add seconds to the Time.now object.
              exp_date = Time.now + (2*365*24*60*60)
              @gift_card.expiry_date = exp_date
              # @gift_card.name =
              @gift_card.save!
              Spree::OrderMailer.check_gift_card(id, @gift_card, line_item).deliver_later
            end
          end
        end
      end
  end

end
