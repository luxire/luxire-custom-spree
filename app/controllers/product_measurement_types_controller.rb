class ProductMeasurementTypesController < ApplicationController
  before_action :set_product_measurement_type, only: [:show, :edit, :update, :destroy]

  # GET /product_measurement_types
  # GET /product_measurement_types.json
  def index
    @product_measurement_types = ProductMeasurementType.all
  end

  # GET /product_measurement_types/1
  # GET /product_measurement_types/1.json
  def show
  end

  # GET /product_measurement_types/new
  def new
    @product_measurement_type = ProductMeasurementType.new
  end

  # GET /product_measurement_types/1/edit
  def edit
  end

  # POST /product_measurement_types
  # POST /product_measurement_types.json
  def create
    @product_measurement_type = ProductMeasurementType.new(product_measurement_type_params)

    respond_to do |format|
      if @product_measurement_type.save
        format.html { redirect_to @product_measurement_type, notice: 'Product measurement type was successfully created.' }
        format.json { render :show, status: :created, location: @product_measurement_type }
      else
        format.html { render :new }
        format.json { render json: @product_measurement_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_measurement_types/1
  # PATCH/PUT /product_measurement_types/1.json
  def update
    respond_to do |format|
      if @product_measurement_type.update(product_measurement_type_params)
        format.html { redirect_to @product_measurement_type, notice: 'Product measurement type was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_measurement_type }
      else
        format.html { render :edit }
        format.json { render json: @product_measurement_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_measurement_types/1
  # DELETE /product_measurement_types/1.json
  def destroy
    @product_measurement_type.destroy
    respond_to do |format|
      format.html { redirect_to product_measurement_types_url, notice: 'Product measurement type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_measurement_type
      @product_measurement_type = ProductMeasurementType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_measurement_type_params
      params.require(:product_measurement_type).permit(:luxire_product_type_id, :measurement_type_id)
    end
end
