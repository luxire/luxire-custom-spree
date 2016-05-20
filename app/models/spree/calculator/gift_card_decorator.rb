Spree::Calculator::GiftCard.class_eval do
        def compute(order, gift_card)
        # Get the order total and gift card current value.
        # Find the minimum of it(Ensuring the order total should not be negative. Read the below comments for clarity.)
        #  and returns the negative of it.
        # Ensure a negative amount which does not exceed the sum of the order's item_total, ship_total, and
        # tax_total, minus other credits.
        # If the gift_card is already applied, recalculate the adjustments based on the current_value
        # As there is a chance that this gift_card is used by someone
        gift_card_adjustment = order.adjustments.where(source: gift_card).take
        if gift_card_adjustment.nil?
          [order.total, gift_card.current_value].min * -1
        else
          total = order.total + gift_card_adjustment.amount.abs
          [total, gift_card.current_value].min * -1
        end
      end

end
