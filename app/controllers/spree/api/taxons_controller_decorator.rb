Spree::Api::TaxonsController.class_eval do

  def create
    authorize! :create, Spree::Taxon
    @taxon = Spree::Taxon.new(taxon_params)
    @taxon.taxonomy_id = params[:taxonomy_id]
    taxonomy = Spree::Taxonomy.find_by(id: params[:taxonomy_id])

    if taxonomy.nil?
      @taxon.errors[:taxonomy_id] = I18n.t(:invalid_taxonomy_id, scope: 'spree.api')
      invalid_resource!(@taxon) and return
    end

    @taxon.parent_id = taxonomy.root.id unless params[:taxon][:parent_id]
    product_ids = params[:taxon][:product_ids]
    unless product_ids.nil?
      @taxon.product_ids= product_ids
    end
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
    attributes = { title: "spree_products.name", type: "luxire_product_types.product_type", vendor: "luxire_vendor_masters.name", variant_price: "spree_prices.amount", variant_compare_at_price: "luxire_products.product_compare_at_price", variant_weight: "spree_variants.weight", variant_inventory: "luxire_stocks.virtual_count_on_hands", Mill: "luxire_products.mill", composition: "luxire_products.composition", technical_description: "luxire_products.technical_description", suitable_climate: "luxire_products.suitable_climates", GSM: "luxire_products.gsm", thickness: "luxire_products.thickness", stiffness: "luxire_products.stiffness", wash_care: "luxire_products.wash_care", sales_pitch: "luxire_products.sales_pitch"}
    operator = { equals: "= ", not_equals: "!= ", greater_than_equals_to: ">= ", less_than_equals_to: "<= ", greater_than: "> ", less_than: "< ", starts_with: "LIKE", ends_with: "LIKE", contains: "LIKE", not_contains: "NOT LIKE"}
    decimal_parameters = [:variant_price, :variant_compare_at_price, :variant_weight, :variant_inventory, :stiffness]
    integer_parametes = [:GSM]
    case_in_sensitive_parameters = [:starts_with , :ends_with, :contains, :not_contains, :title]
    attributes_keys = attributes.keys
    operator_keys = operator.keys
    #convert the keys of params to symbol
    # params.symbolize_keys!
    match = params[:match]
    render_response("Match policy is not specified") and return if match.nil?
    match = params[:match].to_sym
    render_response("Unknown match policy") and return if match_policy[match].nil?
    rules = params[:rules]
    query_string = ""
    query_parameters = ""
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
            when "starts_with"
              query_parameters = "'#{value.downcase}%'"
            when "ends_with"
              query_parameters = "'%#{value.downcase}'"
            when "contains", "not_contains"
              query_parameters = "'%#{value.downcase}%'"
            else
              query_parameters = "'#{value}'"
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
    products_sql = "SELECT spree_products.* FROM spree_products INNER JOIN luxire_products ON luxire_products.product_id = spree_products.id INNER JOIN luxire_products luxire_products_spree_products_join ON luxire_products_spree_products_join.product_id = spree_products.id INNER JOIN luxire_product_types ON luxire_product_types.id = luxire_products_spree_products_join.luxire_product_type_id INNER JOIN luxire_products luxire_products_spree_products_join_2 ON luxire_products_spree_products_join_2.product_id = spree_products.id INNER JOIN luxire_vendor_masters ON luxire_vendor_masters.id = luxire_products_spree_products_join_2.luxire_vendor_master_id INNER JOIN spree_variants ON spree_variants.product_id = spree_products.id AND spree_variants.is_master = 'f' AND spree_variants.deleted_at IS NULL INNER JOIN spree_variants variants_spree_products_join ON variants_spree_products_join.product_id = spree_products.id AND variants_spree_products_join.is_master = 'f' AND variants_spree_products_join.deleted_at IS NULL INNER JOIN spree_prices ON spree_prices.variant_id = variants_spree_products_join.id AND spree_prices.deleted_at IS NULL WHERE spree_products.deleted_at IS NULL AND spree_prices.currency = 'USD' "
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
