Spree::GiftCard.class_eval do

attr_accessor :disable_flag
validates :expiry_date, presence: true
validates :disable_enable_notes, presence: true, if: :disable_true

  def disable_true
    disable_flag
  end

  def order_activatable?(order)
     order &&
     expiry_date > Time.now  &&
     current_value > 0 &&
     !self.class.const_get(:UNACTIVATABLE_ORDER_STATES).include?(order.state) &&
     !disable
   end

   def find_reason(order)
     if order.nil?
        "order is nil"
     elsif expiry_date < Time.now
        "Gift card has expired"
     elsif current_value <= 0
        "Gift card is empty"
      elsif UNACTIVATABLE_ORDER_STATES.include?(order.state)
        "Improper state"
      else disable
        "Gift card is disabled"
      end
   end
end
