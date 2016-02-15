class LuxireProductTypeStyleMastersController < Spree::Api::BaseController
  before_action :set_luxire_product_type_style_master, only: [:show, :edit, :update, :destroy]

  # GET /luxire_product_type_style_masters
  # GET /luxire_product_type_style_masters.json
  def index
    @luxire_product_type_style_masters = LuxireProductTypeStyleMaster.all
  end

  # GET /luxire_product_type_style_masters/1
  # GET /luxire_product_type_style_masters/1.json
  def show
  end

  # GET /luxire_product_type_style_masters/new
  def new
    @luxire_product_type_style_master = LuxireProductTypeStyleMaster.new
  end

  # GET /luxire_product_type_style_masters/1/edit
  def edit
  end

  # POST /luxire_product_type_style_masters
  # POST /luxire_product_type_style_masters.json
  def create
    @luxire_product_type_style_master = LuxireProductTypeStyleMaster.new(luxire_product_type_style_master_params)

    respond_to do |format|
      if @luxire_product_type_style_master.save
        format.html { redirect_to @luxire_product_type_style_master, notice: 'Luxire product type style master was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_product_type_style_master }
      else
        format.html { render :new }
        format.json { render json: @luxire_product_type_style_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_product_type_style_masters/1
  # PATCH/PUT /luxire_product_type_style_masters/1.json
  def update
    respond_to do |format|
      if @luxire_product_type_style_master.update(luxire_product_type_style_master_params)
        format.html { redirect_to @luxire_product_type_style_master, notice: 'Luxire product type style master was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_product_type_style_master }
      else
        format.html { render :edit }
        format.json { render json: @luxire_product_type_style_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_product_type_style_masters/1
  # DELETE /luxire_product_type_style_masters/1.json
  def destroy
    @luxire_product_type_style_master.destroy
    respond_to do |format|
      format.html { redirect_to luxire_product_type_style_masters_url, notice: 'Luxire product type style master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_product_type_style_master
      @luxire_product_type_style_master = LuxireProductTypeStyleMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_product_type_style_master_params
      params.require(:luxire_product_type_style_master).permit(:luxire_product_type_id, :luxire_style_master_id)
    end
end
