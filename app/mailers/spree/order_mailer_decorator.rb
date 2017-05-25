Spree::OrderMailer.class_eval do
  def confirm_email(order, resend = false)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    filter
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
    mail(to: @order.email, bcc: "suman@luxire.com",from: from_address, subject: subject)
  end

  def check_gift_card(order, gift_card_details, line_item)
    @gift_card = gift_card_details
    @line_item = line_item
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    # subject = "Please find your Gift card details for order number #{@order.number}"
    subject = "Your Luxire gift card is ready!"
    @gift_card.update_attribute(:sent_at, Time.now)
    mail(to: @order.email, from: from_address,subject: subject)
  end

  def send_mail_for_backorder(product)
    @product = product
    subject = "Please order fabric"
    mail(to: from_address, from: from_address,subject: subject)
  end


  def filter
     line_items =  @order.line_items
     line_items.each do |line_item|
         luxire_line_item = line_item.luxire_line_item
         unless luxire_line_item.nil?
             customized_data = luxire_line_item.customized_data
             personalize_data = luxire_line_item.personalize_data
             measurement_data = luxire_line_item.measurement_data
             standard_measurement_attributes = measurement_data["standard_measurement_attributes"]
             body_measurement_attributes = measurement_data["body_measurement_attributes"]
             remove_nil_data(customized_data);
             remove_nil_data(personalize_data);
             remove_nil_data(standard_measurement_attributes);
             remove_nil_data(body_measurement_attributes);
        end
       end
  end

# Get the parent_keys.
# Iterate over the parent object based on the keys and get the child_obj based on the child keys.
# Check if the child obj is also a hash. If so, Iterate over it and check whether the keys has a value,
# i.e the key is not blank. In case if it blank, delete it from a hash
# if the child obj is not a hash, then just check it's value and if it blank, delete it from a hash.
  def remove_nil_data(custom_data)
    parent_keys = custom_data.keys
    parent_keys.each do |key|
      parent_obj = custom_data[key]
      child_keys = parent_obj.keys
      child_keys.each do |child_key|
        child_obj = parent_obj[child_key]
        if child_obj.class.to_s == "Hash"
          grand_child_keys = child_obj.keys
          grand_child_keys.each do |grand_child_key|
            child_obj.delete(grand_child_key) if  child_obj[grand_child_key].blank?
          end
        end
        parent_obj.delete(child_key) if  parent_obj[child_key].blank?
      end
      custom_data.delete(key) if custom_data[key].blank?
    end
  end
end
