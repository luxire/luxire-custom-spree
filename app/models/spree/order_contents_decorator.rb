Spree::OrderContents.class_eval do

  def add(variant, quantity = 1, options = {}, luxire_line_item)
        timestamp = Time.now
        line_item = add_to_line_item(variant, quantity, options, luxire_line_item)
        options[:line_item_created] = true if timestamp <= line_item.created_at
        after_add_or_remove(line_item, options)
      end

  def add_to_line_item(variant, quantity, options = {}, luxire_line_item)
    # byebug
     line_item = grab_line_item_by_variant(variant, false, options)

    #  if line_item
    #    line_item.quantity += quantity.to_i
    #    line_item.currency = currency unless currency.nil?
    #  else
       opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                           permit(Spree::PermittedAttributes.line_item_attributes)
       line_item = order.line_items.new(quantity: quantity,
                                         variant: variant,
                                         options: opts)
    #  end
     line_item.target_shipment = options[:shipment] if options.has_key? :shipment
    #  Creating a transaction for line item and luxire line item
     Spree::LineItem.transaction do
       line_item.save!
       unless luxire_line_item.empty?
          #  Create LuxireLineItem
           lux_line_item = LuxireLineItem.create!(luxire_line_item)
          #  Created the association
           line_item.luxire_line_item = lux_line_item
           line_item.save!
          #  If the line item contains personalization_cost put it in the PersonalizationCost model
          # As well as Adjustment model and update the order
          # byebug
           unless luxire_line_item[:total_personalization_cost] == 0
             personalization_cost = PersonalizationCost.new
             personalization_cost.cost = luxire_line_item[:total_personalization_cost]
             personalization_cost.line_item_id = line_item.id
             personalization_cost.save!
            #  Fetch the order from line_item and update it
            order = line_item.order
            order.update!
            #  Create the adjustment and update the order details
             Spree::Adjustment.create!(
                   amount: personalization_cost.cost,
                   order: order,
                   adjustable: line_item,
                   source: personalization_cost,
                   mandatory: true,
                   label: "#{Spree.t(:personalization_cost)}"
                 )
             # Call line_item.save! method so that it can recalculate the adjustments
             # And then update the order so that the adjustments are reflected to order
             line_item.save!
             order.update!
           end
        end
      end
     line_item
   end


   def update_cart(params)
     update_personalization_cost(params)
     if order.update_attributes(filter_order_items(params))
       order.line_items = order.line_items.select { |li| li.quantity > 0 }
       # Update totals, then check if the order is eligible for any cart promotions.
       # If we do not update first, then the item total will be wrong and ItemTotal
       # promotion rules would not be triggered.
       persist_totals
       Spree::PromotionHandler::Cart.new(order).activate
       order.ensure_updated_shipments
       persist_totals
       true
     else
       false
     end
   end

   def update_personalization_cost(params)
     filtered_params = params.symbolize_keys
     return if filtered_params[:line_items_attributes].nil? 
     return unless filtered_params[:line_items_attributes][:id] && filtered_params[:line_items_attributes][:quantity]
     line_item = Spree::LineItem.find(filtered_params[:line_items_attributes][:id])
     quantity = (filtered_params[:line_items_attributes][:quantity].to_i - line_item.quantity).abs
     return if quantity <= 0
     personalization_adjustments = line_item.adjustments.where(source_type: "PersonalizationCost").take
     unless personalization_adjustments.nil?
       cost = personalization_adjustments.amount / line_item.quantity
       personalization_adjustments.amount =  cost * filtered_params[:line_items_attributes][:quantity].to_i
       personalization_adjustments.save!
     end
   end
end
