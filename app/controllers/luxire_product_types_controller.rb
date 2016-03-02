class LuxireProductTypesController < Spree::Api::BaseController
  wrap_parameters format: [:json, :xml, :url_encoded_form, :multipart_form]
  wrap_parameters :luxire_product_type, include: [:id, :product_type, :description, :measurement_type_ids, :image]

  before_action :set_luxire_product_type, only: [:show, :edit, :update, :destroy]
  require 'ostruct'

  # GET /luxire_product_types
  # GET /luxire_product_types.json
  def index
    @luxire_product_types = LuxireProductType.all
  end

  # GET /luxire_product_types/1
  # GET /luxire_product_types/1.json
  def show
    logger.debug "params in show #{params}"
     @luxire_product_type = LuxireProductType.find(params[:id])

#    @luxire_product_type = LuxireProductType.find(params[:id]).attributes
#    @luxire_product_type[:mnt] = Hash.new
 #   @luxire_product_type[:mnt][:customize] = LuxireProductType.find(params[:id]).measurement_types.where(category: "customize")


#	@luxire_p_t =  OpenStruct.new(@luxire_product_type)
#@luxire_product_type = @luxire_p_t
    @luxire_product_type_attributes = @luxire_product_type.measurement_types
    @luxire_product_type_attributes_ids = @luxire_product_type.measurement_types.ids
    @luxire_product_type_attributes_customize = @luxire_product_type_attributes.where(category: "customize")
    @luxire_product_type_attributes_personalize = @luxire_product_type_attributes.where(category: "personalize")
    @luxire_product_type_attributes_measurement = @luxire_product_type_attributes.where(category: "measurement")
    @luxire_product_type_attributes_measuement_std = @luxire_product_type_attributes.where(sub_category: "std")
    @luxire_product_type_attributes_measuement_body = @luxire_product_type_attributes.where(sub_category: "body")

    @luxire_custom = { id: @luxire_product_type.id,product_type: @luxire_product_type.product_type, description: @luxire_product_type.description, image: @luxire_product_type.image, measurement_types: @luxire_product_type_attributes, luxire_product_attributes_ids: @luxire_product_type_attributes_ids,luxire_product_attributes: {customization_attributes: @luxire_product_type_attributes_customize, personalization_attributes:  @luxire_product_type_attributes_personalize,standard_measurement_attributes: @luxire_product_type_attributes_measuement_std, body_measurement_attributes: @luxire_product_type_attributes_measuement_body}}

    render json: @luxire_custom.to_json
  end

  # GET /luxire_product_types/new
  def new
    @luxire_product_type = LuxireProductType.new
  end

  # GET /luxire_product_types/1/edit
  def edit
  end

  # POST /luxire_product_types
  # POST /luxire_product_types.json
  def create
    @luxire_product_type = LuxireProductType.new(luxire_product_type_params)

    if(params[:luxire_product_type][:measurement_type_ids])
      if(params[:luxire_product_type][:measurement_type_ids].length>0)
        @luxire_product_type.measurement_type_ids = params[:measurement_type_ids]
      end
    end

    respond_to do |format|
      if @luxire_product_type.save
        format.html { redirect_to @luxire_product_type, notice: 'Luxire product type was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_product_type }
      else
        format.html { render :new }
        format.json { render json: @luxire_product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_product_types/1
  # PATCH/PUT /luxire_product_types/1.json
  def update
    if(params[:luxire_product_type][:measurement_type_ids])
      if(params[:luxire_product_type][:measurement_type_ids].length>0)
        @luxire_product_type.measurement_type_ids = params[:measurement_type_ids]
      end
    end
    respond_to do |format|
      if @luxire_product_type.update(luxire_product_type_params)
        format.html { redirect_to @luxire_product_type, notice: 'Luxire product type was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_product_type }
      else
        format.html { render :edit }
        format.json { render json: @luxire_product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_product_types/1
  # DELETE /luxire_product_types/1.json
  def destroy
    @luxire_product_type.destroy
    respond_to do |format|
      format.html { redirect_to luxire_product_types_url, notice: 'Luxire product type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_product_type
      @luxire_product_type = LuxireProductType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_product_type_params
      params.require(:luxire_product_type).permit(:product_type, :description, :measurement_type_ids, :image)
    end
end
