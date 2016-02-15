class LuxireVendorMastersController < Spree::Api::BaseController
  before_action :set_luxire_vendor_master, only: [:show, :edit, :update, :destroy]

  # GET /luxire_vendor_masters
  # GET /luxire_vendor_masters.json
  def index
    @luxire_vendor_masters = LuxireVendorMaster.all
  end

  # GET /luxire_vendor_masters/1
  # GET /luxire_vendor_masters/1.json
  def show
  end

  # GET /luxire_vendor_masters/new
  def new
    @luxire_vendor_master = LuxireVendorMaster.new
  end

  # GET /luxire_vendor_masters/1/edit
  def edit
  end

  # POST /luxire_vendor_masters
  # POST /luxire_vendor_masters.json
  def create
    @luxire_vendor_master = LuxireVendorMaster.new(luxire_vendor_master_params)

    respond_to do |format|
      if @luxire_vendor_master.save
        format.html { redirect_to @luxire_vendor_master, notice: 'Luxire vendor master was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_vendor_master }
      else
        format.html { render :new }
        format.json { render json: @luxire_vendor_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_vendor_masters/1
  # PATCH/PUT /luxire_vendor_masters/1.json
  def update
    respond_to do |format|
      if @luxire_vendor_master.update(luxire_vendor_master_params)
        format.html { redirect_to @luxire_vendor_master, notice: 'Luxire vendor master was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_vendor_master }
      else
        format.html { render :edit }
        format.json { render json: @luxire_vendor_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_vendor_masters/1
  # DELETE /luxire_vendor_masters/1.json
  def destroy
    @luxire_vendor_master.destroy
    respond_to do |format|
      format.html { redirect_to luxire_vendor_masters_url, notice: 'Luxire vendor master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_vendor_master
      @luxire_vendor_master = LuxireVendorMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_vendor_master_params
      params.require(:luxire_vendor_master).permit(:name)
    end
end
