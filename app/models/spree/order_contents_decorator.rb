Spree::OrderContents.class_eval do

  def add(variant, quantity = 1, options = {}, luxire_line_item)
        timestamp = Time.now
        line_item = add_to_line_item(variant, quantity, options, luxire_line_item)
        options[:line_item_created] = true if timestamp <= line_item.created_at
        after_add_or_remove(line_item, options)
      end

  def add_to_line_item(variant, quantity, options = {}, luxire_line_item)
     line_item = grab_line_item_by_variant(variant, false, options)

     if line_item
       line_item.quantity += quantity.to_i
       line_item.currency = currency unless currency.nil?
     else
       opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                           permit(Spree::PermittedAttributes.line_item_attributes)
       line_item = order.line_items.new(quantity: quantity,
                                         variant: variant,
                                         options: opts)
     end
     line_item.target_shipment = options[:shipment] if options.has_key? :shipment
    #  Creating a transaction for line item and luxire line item
     Spree::LineItem.transaction do
       line_item.save!
       unless luxire_line_item.empty?
          #  Created LuxireLineItem
           lux_line_item = LuxireLineItem.create!(luxire_line_item)
          #  Created the association
           line_item.luxire_line_item = lux_line_item
           line_item.save!
         end
      end
     line_item
   end

end
