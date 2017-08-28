Spree::Api::ProductsController.class_eval do
respond_to :html, :json
helper LuxireStyleMastersHelper
  # product_params method whitelist all the parameter for mass assignment
    def show
     @product = find_product(params[:id])
     expires_in 15.minutes, :public => true
     headers['Surrogate-Control'] = "max-age=#{15.minutes}"
     headers['Surrogate-Key'] = "product_id=1"
     @product_type = LuxireProductType.all
     @luxire_vendor = LuxireVendorMaster.all
     @luxire_product_type =  @product.luxire_product_type
     if @luxire_product_type
       @luxire_product_type_attributes = @luxire_product_type.measurement_types
      @luxire_product_type_attributes = MeasurementType.joins("INNER JOIN product_measurement_types ON product_measurement_types.measurement_type_id = measurement_types.id AND product_measurement_types.luxire_product_type_id = " + @luxire_product_type.id.to_s).order("product_measurement_types.position")
       if @luxire_product_type_attributes
          @luxire_product_type_attributes_customize = @luxire_product_type_attributes.where(category: "customize")
          @luxire_product_type_attributes_personalize = @luxire_product_type_attributes.where(category: "personalize")
          @luxire_product_type_attributes_measurement = @luxire_product_type_attributes.where(category: "measurement")
          @luxire_product_type_attributes_measuement_std = @luxire_product_type_attributes.where(sub_category: "std")
          @luxire_product_type_attributes_measuement_body = @luxire_product_type_attributes.where(sub_category: "body")
	       end
       end
    end

    def admin_index
      if params[:q]
        @products = Spree::Product.ransack(params[:q]).result
      else
        @products = Spree::Product.all
      end
      #@products = Spree::Product.all
      @products = @products.distinct.page(params[:page]).per(params[:per_page])
      expires_in 15.minutes, :public => true
      headers['Surrogate-Control'] = "max-age=#{15.minutes}"
      respond_with(@products)
    end

    def admin_show
      @product = find_product(params[:id])
      @shipping_methods = Spree::ShippingCategory.all
      expires_in 15.minutes, :public => true
      headers['Surrogate-Control'] = "max-age=#{15.minutes}"
      headers['Surrogate-Key'] = "product_id=1"
      respond_with(@product)
    end

    def index
     if params[:ids]
        @products = product_scope.where(id: params[:ids].split(",").flatten)
     else
        # @products = product_scope.ransack(params[:q]).result
        @products = product_scope.ransack(params[:q]).result.includes(:luxire_stock)
     end

     @products = @products.distinct.page(params[:page]).per(params[:per_page])
     expires_in 15.minutes, :public => true
     headers['Surrogate-Control'] = "max-age=#{15.minutes}"

#     unless params[:q].nil? || params[:q].empty?
 #       render 'search.v1.rabl'
  #   else
        render 'index.v1.rabl'
#     end
    end


    def update
      @product = find_product(params[:id])
      authorize! :update, @product
      priceFlag = false;
      if params[:product][:price] && @product.price != params[:product][:price].to_f
        priceFlag = true;
      end

      options = { variants_attrs: variants_params, options_attrs: option_types_params }
      @product = Spree::Core::Importer::Product.new(@product, product_params, options).update

      if @product.errors.empty?
        if priceFlag
          product_ids = []
          product_ids << @product.id
          Currency.new.update_product_currency(product_ids)
        end
        respond_with(@product.reload, :status => 200, :default_template => :show)
      else
        invalid_resource!(@product)
      end
    end

   def get_additional_service_product
     @product = Spree::Product.where("lower(name) = ?", "additional service").take
     render 'show'
   end

private
  def product_params
    # Get all the column names from luxire_product model. Model.column return an array
    # Strings, where Strings are the model attributes
    luxire_product_permitted_attributes = LuxireProduct.column_names
    # Get all the column names from luxire_stock model. Model.column return an array
    # Strings, where Strings are the model attributes
    luxire_stock_permitted_attributes = LuxireStock.column_names
    # Converting the array of Strings to array of symbols
    luxire_product_permitted_attributes = luxire_product_permitted_attributes.map &:to_sym
    luxire_stock_permitted_attributes = luxire_stock_permitted_attributes.map &:to_sym
    # Creating hash of luxire_stock_attributes
    luxire_stock_permitted_array = {luxire_stock_attributes: luxire_stock_permitted_attributes}
    # adding luxire_stock_attributes to luxire_product_permitted_attributes
    luxire_product_permitted_attributes << luxire_stock_permitted_array
    # Creating the final luxire_product_permitted_array
    luxire_product_permitted_array = [luxire_product_attributes: luxire_product_permitted_attributes]
    # Creating the final permitted array
    permitted_array = permitted_attributes.product_attributes + [
       product_properties_attributes: permitted_product_properties_attributes
          ] + luxire_product_permitted_array
    params.require(:product).permit(permitted_array)
  end

end
