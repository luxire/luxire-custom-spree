Spree::Api::TaxonsController.class_eval do

  wrap_parameters format: [:json, :xml, :url_encoded_form, :multipart_form]
  wrap_parameters :taxon, include: [:name, :pretty_name, :description, :taxonomy_id, :rules, :match, :icon, :product_ids]

  def create
    authorize! :create, Spree::Taxon
    @taxon = Spree::Taxon.new(taxon_params)
    @taxon.taxonomy_id = params[:taxon][:taxonomy_id]
    taxonomy = Spree::Taxonomy.find_by(id: params[:taxon][:taxonomy_id])

    if taxonomy.nil?
      @taxon.errors[:taxonomy_id] = I18n.t(:invalid_taxonomy_id, scope: 'spree.api')
      invalid_resource!(@taxon) and return
    end

    @taxon.parent_id = taxonomy.root.id unless params[:taxon][:parent_id]

    if params[:taxon][:product_ids].class.to_s == "String"
      @product_ids = JSON.parse(params[:taxon][:product_ids])
    else
      @product_ids = params[:taxon][:product_ids]
    end
    unless @product_ids.nil?
      @taxon.product_ids= @product_ids
    end

#    @taxon.icon = params[:taxon][:icon] if params[:taxon][:icon]

    if @taxon.save
      respond_with(@taxon, status: 201, default_template: :show)
    else
      invalid_resource!(@taxon)
    end
  end

# Create collection based on rules for selecting the product
# e.g select all product whose price is more than $100
  def dynamic_collection_create
    authorize! :create, Spree::Taxon
    match_policy = {all: "and", any: "or"}
    # Time being removing tag from attributes hash.
    # Should add Tag in attributes hash once tag implementation is done
    attributes = { "Product title": "spree_products.name", "Product type": "luxire_product_types.product_type", "Product vendor": "luxire_vendor_masters.name", "Product price": "spree_prices.amount", "Compare at price": "luxire_products.product_compare_at_price", Weight: "spree_variants.weight", "Inventory stock": "luxire_stocks.virtual_count_on_hands", Mill: "luxire_products.mill", Composition: "luxire_products.composition", "Technical description": "luxire_products.technical_description", "Suitable climate": "luxire_products.suitable_climates", GSM: "luxire_products.gsm",
               Thickness: "luxire_products.thickness", Stiffness: "luxire_products.stiffness", "Wash care": "luxire_products.wash_care", "Sales pitch ": "luxire_products.sales_pitch",
               "Weave type": "luxire_products.product_weave_type", Design: "luxire_products.pattern", Color: "luxire_products.product_color",
            "no. of color": "luxire_products.no_of_color" 
             }
operator = { "is equal to": "= ", "is not equal to": "!= ", "greater than equals to": ">= ", "lesser than equals to": "<= ", "is greater than": "> ", "is less than": "< ", "starts with": "LIKE", "ends with": "LIKE", contains: "LIKE", "does not contain": "NOT LIKE"}

    decimal_parameters = [:"Product price", :"Compare at price", :Weight, :"Inventory stock", :Stiffness]
integer_parametes = [:GSM, :"no. of color"]
case_in_sensitive_parameters = [:"Product title", :"Product type", :"Product vendor", :Mill, :Composition, :"Technical description", :"Suitable climate", :Thickness, :"Wash care", :"Sales pitch ", :"Weave type", :Design, :Color]
    attributes_keys = attributes.keys
    operator_keys = operator.keys
    #convert the keys of params to symbol
    # params.symbolize_keys!
    match = params[:taxon][:match]
    render_response("Match policy is not specified") and return if match.nil?
    match = params[:taxon][:match].to_sym
    render_response("Unknown match policy") and return if match_policy[match].nil?
    rules = params[:taxon][:rules]
    query_string = ""
    query_parameters = ""
    rules = JSON.parse(rules)
    begin
      rules.each do |rule|
        rule = rule.symbolize_keys
        property = rule[:property].to_sym
        criteria = rule[:criteria].to_sym
        value = rule[:value]
        render_response("can not create collection because of unknown property #{property}") and return unless attributes_keys.include? (property)
        render_response("can not create collection because of unknown criteria #{criteria}") and return unless operator_keys.include? (criteria)
        if decimal_parameters.include? property
          query_parameters = "#{BigDecimal(value)}"
        elsif integer_parametes.include? property
          query_parameters = "#{Integer(value)}"
        else
          case criteria.to_s
            when "starts with"
              query_parameters = "'#{value.downcase}%'"
            when "ends with"
              query_parameters = "'%#{value.downcase}'"
            when "contains", "does not contain"
              query_parameters = "'%#{value.downcase}%'"
            else
              query_parameters = "'#{value.downcase}'"
            end
        end
        if case_in_sensitive_parameters.include? property
          query_string << " #{match_policy[match]} LOWER(#{attributes[property]}) #{operator[criteria]} #{query_parameters}"
        else
          query_string << " #{match_policy[match]} #{attributes[property]} #{operator[criteria]} #{query_parameters}"
        end
      end
    rescue Expection => e
        render_response("can not create collection because of e.message") and return
    end
    query_string[0..match.length] = "And ("
    query_string[query_string.length] = ")"
    products_sql = "SELECT spree_products.* FROM spree_products INNER JOIN luxire_products ON luxire_products.product_id = spree_products.id INNER JOIN luxire_products luxire_products_spree_products_join ON luxire_products_spree_products_join.product_id = spree_products.id INNER JOIN luxire_product_types ON luxire_product_types.id = luxire_products_spree_products_join.luxire_product_type_id INNER JOIN luxire_products luxire_products_spree_products_join_2 ON luxire_products_spree_products_join_2.product_id = spree_products.id INNER JOIN luxire_vendor_masters ON luxire_vendor_masters.id = luxire_products_spree_products_join_2.luxire_vendor_master_id INNER JOIN spree_variants ON spree_variants.product_id = spree_products.id AND spree_variants.is_master = 't' AND spree_variants.deleted_at IS NULL INNER JOIN spree_variants variants_spree_products_join ON variants_spree_products_join.product_id = spree_products.id AND variants_spree_products_join.is_master = 't' AND variants_spree_products_join.deleted_at IS NULL INNER JOIN spree_prices ON spree_prices.variant_id = variants_spree_products_join.id AND spree_prices.deleted_at IS NULL WHERE spree_products.deleted_at IS NULL AND spree_prices.currency = 'USD' "
    products =  Spree::Product.find_by_sql( products_sql + query_string )
    product_ids = products.collect {|p| p.id}
    params[:taxon][:product_ids] = product_ids
    create
  end

  def update
    authorize! :update, taxon
    product_ids = params[:taxon][:product_ids]
    unless product_ids.nil?
      @taxon.product_ids= product_ids
    end
    if taxon.update_attributes(taxon_params)
      respond_with(taxon, status: 200, default_template: :show)
    else
      invalid_resource!(taxon)
    end
  end

  private
  def render_response(message)
    response = {msg: message}
    render json: response.to_json, status: "422"
  end
end
