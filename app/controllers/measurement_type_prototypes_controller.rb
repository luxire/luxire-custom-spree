class MeasurementTypePrototypesController < ApplicationController
  before_action :set_measurement_type_prototype, only: [:show, :edit, :update, :destroy]

  # GET /measurement_type_prototypes
  # GET /measurement_type_prototypes.json
  def index
    @measurement_type_prototypes = MeasurementTypePrototype.all
  end

  # GET /measurement_type_prototypes/1
  # GET /measurement_type_prototypes/1.json
  def show
  end

  # GET /measurement_type_prototypes/new
  def new
    @measurement_type_prototype = MeasurementTypePrototype.new
  end

  # GET /measurement_type_prototypes/1/edit
  def edit
  end

  # POST /measurement_type_prototypes
  # POST /measurement_type_prototypes.json
  def create
    @measurement_type_prototype = MeasurementTypePrototype.new(measurement_type_prototype_params)

    respond_to do |format|
      if @measurement_type_prototype.save
        format.html { redirect_to @measurement_type_prototype, notice: 'Measurement type prototype was successfully created.' }
        format.json { render :show, status: :created, location: @measurement_type_prototype }
      else
        format.html { render :new }
        format.json { render json: @measurement_type_prototype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /measurement_type_prototypes/1
  # PATCH/PUT /measurement_type_prototypes/1.json
  def update
    respond_to do |format|
      if @measurement_type_prototype.update(measurement_type_prototype_params)
        format.html { redirect_to @measurement_type_prototype, notice: 'Measurement type prototype was successfully updated.' }
        format.json { render :show, status: :ok, location: @measurement_type_prototype }
      else
        format.html { render :edit }
        format.json { render json: @measurement_type_prototype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /measurement_type_prototypes/1
  # DELETE /measurement_type_prototypes/1.json
  def destroy
    @measurement_type_prototype.destroy
    respond_to do |format|
      format.html { redirect_to measurement_type_prototypes_url, notice: 'Measurement type prototype was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement_type_prototype
      @measurement_type_prototype = MeasurementTypePrototype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def measurement_type_prototype_params
      params.require(:measurement_type_prototype).permit(:name, :value)
    end
end
