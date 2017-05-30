module Spree
   Api::ClassificationsController.class_eval do
      def update
        authorize! :update, Product
        authorize! :update, Taxon
        classification = Spree::Classification.find_by(
          :product_id => params[:product_id],
          :taxon_id => params[:taxon_id]
        )
        # Because position we get back is 0-indexed.
        # acts_as_list is 1-indexed.
        begin
         classification.insert_at(params[:position].to_i + 1)
         response = {msg: 'Position Updated successfully'}
         render json: response.to_json, status: 200
        rescue Exception => e
         response = {msg: 'Error while updating position, and the reason is: #{e}'}
         render json: response.to_json, status: 500
        end
      end
   
    def updatePositionBasedOnCondition 
      authorize! :update, Product
      authorize! :update, Taxon
      begin
        taxon = Spree::Taxon.find(params[:taxonId])
      rescue Exception => e
        response = { msg: "Exception while finding taxon and the reason is #{e}"}
        render json: response.to_json, status: 422 and return
      end
      ids = taxon.product_ids
      unless ids.empty?
       products =  Spree::Product.where(id: ids)
      else
       response = {msg: "No Product to Sort"}
       render json: msg.to_json, status: 200 and return
      end 
      order_by = params[:orderBy]  
      condition = params[:condition]
      conditions_hash = {name: "name", price: "spree_prices.amount", date: "created_at"} 
      order_by_condition = "#{conditions_hash[condition.to_sym]} #{order_by}"
      if condition == "price"
       sorted_products =  products.joins(:prices).where("spree_prices.currency =?", "USD").order(order_by_condition)
      else
       sorted_products =  products.order(order_by_condition)
      end
      Spree::Taxon.transaction do
       taxon.product_ids = []
       taxon.product_ids = sorted_products.ids
      end
      response = {msg: "Product sorted successfully.", ids: taxon.product_ids}
      render json: response.to_json, status: 200  
     # render json: taxon.products.to_json, status: 200 
    end
  end
end
