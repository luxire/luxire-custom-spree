Spree::Api::OrdersController.class_eval do
private
  def order_params
    if params[:order]
      normalize_params
      # # Getting all the column names of LuxireLineItem and converting it into symbol
      # luxire_line_items = LuxireLineItem.column_names
      # luxire_line_items -= ["created_at", "updated_at"]
      # # Get all the permitted_order_attributes and convert it to string and assign it to modified_permitted_order_attributes
      # # so that manipulating the value will not have any impact on permitted_order_attributes
      # modified_permitted_order_attributes = permitted_order_attributes.each { |x| x.to_s}
      # # Create luxire_line_items_hash. Add this hash to line_items array
      # luxire_line_items_hash = { "luxire_line_item_attributes": luxire_line_items }
      # # Get the line_items and delete it from the root array
      # line_items = permitted_order_attributes.last
      # modified_line_items = modified_permitted_order_attributes.pop
      # byebug
      # # Adding the hash to line_items array
      # modified_line_items[:line_items_attributes].push(luxire_line_items_hash)
      # # Adding th array back to modified_permitted_order_attributes
      # modified_permitted_order_attributes << modified_line_items
      # # Replace the last item of permitted_order_attributes with the previous value.
      # # The last value of permitted_order_attributes has changed since we have used
      # # :line_items_attributes symbol
      # permitted_order_attributes.pop
      # permitted_order_attributes << line_items
      # byebug
      # params.require(:order).permit(modified_permitted_order_attributes)
      params.require(:order).permit!
    else
      {}
    end
  end

end
