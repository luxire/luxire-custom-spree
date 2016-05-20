Spree::OrderMailer.class_eval do
  def confirm_email(order, resend = false)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
    mail(to: @order.email, from: from_address, subject: subject)
  end

  def check_gift_card(order, gift_card_details, line_item)
    @gift_card = gift_card_details
    @line_item = line_item
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    subject = "Please find your Gift card details for order number #{@order.number}"
    @gift_card.update_attribute(:sent_at, Time.now)
    mail(to: @order.email, from: from_address,subject: subject)
  end

  def send_mail_for_backorder(product)
    @product = product
    subject = "Please order fabric"
    mail(to: from_address, from: from_address,subject: subject)
  end
end
