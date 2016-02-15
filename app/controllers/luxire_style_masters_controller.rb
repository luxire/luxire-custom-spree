class LuxireStyleMastersController < Spree::Api::BaseController
  before_action :set_luxire_style_master, only: [:show, :edit, :update, :destroy]

  # GET /luxire_style_masters
  # GET /luxire_style_masters.json
  def index
    logger.debug "params #{params[:product_type_id]}"
    if params[:product_type_id]
      @luxire_style_masters = LuxireStyleMaster.where(luxire_product_type_id: params[:product_type_id])
    else
      @luxire_style_masters = LuxireStyleMaster.all
    end
  end

  # GET /luxire_style_masters/1
  # GET /luxire_style_masters/1.json
  def show
    render 'show.json.rabl'
  end


  # GET /luxire_style_masters/new
  def new
    @luxire_style_master = LuxireStyleMaster.new
  end

  # GET /luxire_style_masters/1/edit
  def edit
  end

  # POST /luxire_style_masters
  # POST /luxire_style_masters.json
  def create
    @luxire_style_master = LuxireStyleMaster.new(luxire_style_master_params)

    respond_to do |format|
      if @luxire_style_master.save
        format.html { redirect_to @luxire_style_master, notice: 'Luxire style master was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_style_master }
      else
        format.html { render :new }
        format.json { render json: @luxire_style_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_style_masters/1
  # PATCH/PUT /luxire_style_masters/1.json
  def update
    respond_to do |format|
      if @luxire_style_master.update(luxire_style_master_params)
        format.html { redirect_to @luxire_style_master, notice: 'Luxire style master was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_style_master }
      else
        format.html { render :edit }
        format.json { render json: @luxire_style_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_style_masters/1
  # DELETE /luxire_style_masters/1.json
  def destroy
    @luxire_style_master.destroy
    respond_to do |format|
      format.html { redirect_to luxire_style_masters_url, notice: 'Luxire style master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_style_master
      @luxire_style_master = LuxireStyleMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_style_master_params
      params.require(:luxire_style_master).permit!
    end
end
