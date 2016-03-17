Spree::Api::LineItemsController.class_eval do

  def create
    variant = Spree::Variant.find(params[:line_item][:variant_id])
    @line_item = order.contents.add(
        variant,
        params[:line_item][:quantity] || 1,
        line_item_params[:options] || {},
        params[:line_item][:luxire_line_item] || {}
    )

    if @line_item.errors.empty?
      respond_with(@line_item, status: 201, default_template: :show)
    else
      invalid_resource!(@line_item)
    end
  end



private
  def line_item_params
    params.require(:line_item).permit!
  end

end
