Spree::Api::LineItemsController.class_eval do
  before_action :check_luxire_inventory, only: [ :create, :update ]

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

  def check_luxire_inventory
    line_item = params[:line_item]
    variant = Spree::Variant.find(line_item["variant_id"])
    product = variant.product
    unless Spree::Product.non_depletable_product.include? product.name.downcase
      length_required_per_product = product.luxire_product.length_required
      quantity = line_item["quantity"].to_i
      stock = product.luxire_stock
      unless stock.backorderable
        total_length_required = length_required_per_product * quantity
        if(stock.virtual_count_on_hands - total_length_required < 0)
          response = {msg: "#{product.name} is out of stock"}
          render json: response.to_json, status: 422
        end
      end
    end
  end

end
