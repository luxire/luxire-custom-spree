Spree::Api::VariantsController.class_eval do
   before_action :check_price, only: [:create, :update]
   def check_price
     if @product.is_gift_card?
       if params[:variant].nil? || params[:variant][:price].nil?
         response = {msg: "Gift card variants price can not be blank"}
         render json: response.to_json, status: "422"
         return
       end
       price = params[:variant][:price]
       @product.variants.each do |variant|
         if(variant.price == price)
           response = {msg: "Gift card variants should have a unique price"}
           render json: response.to_json, status: "422"
           return
         end
       end
     end
   end
end
