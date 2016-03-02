class LuxirePropertiesController < ApplicationController
  before_action :set_luxire_property, only: [:show, :edit, :update, :destroy]

  # GET /luxire_properties
  # GET /luxire_properties.json
  def index
    @luxire_properties = LuxireProperty.all
  end

  # GET /luxire_properties/1
  # GET /luxire_properties/1.json
  def show
  end

  # GET /luxire_properties/new
  def new
    @luxire_property = LuxireProperty.new
  end

  # GET /luxire_properties/1/edit
  def edit
  end

  # POST /luxire_properties
  # POST /luxire_properties.json
  def create
    @luxire_property = LuxireProperty.new(luxire_property_params)

    respond_to do |format|
      if @luxire_property.save
        format.html { redirect_to @luxire_property, notice: 'Luxire property was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_property }
      else
        format.html { render :new }
        format.json { render json: @luxire_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_properties/1
  # PATCH/PUT /luxire_properties/1.json
  def update
    respond_to do |format|
      if @luxire_property.update(luxire_property_params)
        format.html { redirect_to @luxire_property, notice: 'Luxire property was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_property }
      else
        format.html { render :edit }
        format.json { render json: @luxire_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_properties/1
  # DELETE /luxire_properties/1.json
  def destroy
    @luxire_property.destroy
    respond_to do |format|
      format.html { redirect_to luxire_properties_url, notice: 'Luxire property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_property
      @luxire_property = LuxireProperty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_property_params
      params.require(:luxire_property).permit(:name, :value, :product_type_id)
    end
end
