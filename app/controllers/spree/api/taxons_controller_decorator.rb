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
end
