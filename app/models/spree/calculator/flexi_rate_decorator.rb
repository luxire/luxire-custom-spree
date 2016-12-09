 Spree::Calculator::FlexiRate.class_eval do

   def compute(object)
     sum = 0
     max = self.preferred_max_items.to_i
     items_count = object.quantity
     items_count.times do |i|
       if i == 0
         if preferred_currency.upcase == object.currency.upcase
           first_item = preferred_first_item.to_f
         else
           first_item = Currency.new.get_price_for_other_currency(preferred_first_item.to_f, preferred_currency.upcase, object.currency.upcase)
         end
         sum += first_item
       elsif ((max > 0) && (i <= (max - 1))) || (max == 0)
         if preferred_currency.upcase == object.currency.upcase
           additional_item = preferred_additional_item.to_f
         else
           additional_item = Currency.new.get_price_for_other_currency(preferred_additional_item.to_f, preferred_currency.upcase, object.currency.upcase)
         end
         sum += additional_item
       end
     end

     sum
   end

 end
