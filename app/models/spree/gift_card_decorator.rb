Spree::GiftCard.class_eval do

attr_accessor :disable_flag
validates :expiry_date, presence: true
validates :disable_enable_notes, presence: true, if: :disable_true


   def generate_code
      until self.code.present? && self.class.where(code: self.code).count == 0
        self.code = Digest::SHA1.hexdigest([Time.now, rand].join)[0...8]
      end
    end

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
