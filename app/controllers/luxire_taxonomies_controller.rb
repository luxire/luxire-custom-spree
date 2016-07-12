class LuxireTaxonomiesController < ApplicationController
  before_action :set_luxire_taxonomy, only: [:show, :edit, :update, :destroy]

  # GET /luxire_taxonomies
  # GET /luxire_taxonomies.json
  def index
    @luxire_taxonomies = LuxireTaxonomy.all
  end

  # GET /luxire_taxonomies/1
  # GET /luxire_taxonomies/1.json
  def show
  end

  # GET /luxire_taxonomies/new
  def new
    @luxire_taxonomy = LuxireTaxonomy.new
  end

  # GET /luxire_taxonomies/1/edit
  def edit
  end

  # POST /luxire_taxonomies
  # POST /luxire_taxonomies.json
  def create
    @luxire_taxonomy = LuxireTaxonomy.new(luxire_taxonomy_params)

    respond_to do |format|
      if @luxire_taxonomy.save
        format.html { redirect_to @luxire_taxonomy, notice: 'Luxire taxonomy was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_taxonomy }
      else
        format.html { render :new }
        format.json { render json: @luxire_taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_taxonomies/1
  # PATCH/PUT /luxire_taxonomies/1.json
  def update
    respond_to do |format|
      if @luxire_taxonomy.update(luxire_taxonomy_params)
        format.html { redirect_to @luxire_taxonomy, notice: 'Luxire taxonomy was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_taxonomy }
      else
        format.html { render :edit }
        format.json { render json: @luxire_taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_taxonomies/1
  # DELETE /luxire_taxonomies/1.json
  def destroy
    @luxire_taxonomy.destroy
    respond_to do |format|
      format.html { redirect_to luxire_taxonomies_url, notice: 'Luxire taxonomy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_taxonomy
      @luxire_taxonomy = LuxireTaxonomy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_taxonomy_params
      params.require(:luxire_taxonomy).permit(:mega_menu_template, :spree_taxonomy_id)
    end
end
