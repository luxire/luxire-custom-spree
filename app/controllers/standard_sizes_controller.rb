class StandardSizesController < ApplicationController
  before_action :set_standard_size, only: [:show, :edit, :update, :destroy]

  # GET /standard_sizes
  # GET /standard_sizes.json
  def index
    @standard_sizes = StandardSize.all
  end

  # GET /standard_sizes/1
  # GET /standard_sizes/1.json
  def show
  end

  # GET /standard_sizes/new
  def new
    @standard_size = StandardSize.new
  end

  # GET /standard_sizes/1/edit
  def edit
  end

  # POST /standard_sizes
  # POST /standard_sizes.json
  def create
    @standard_size = StandardSize.new(standard_size_params)

    respond_to do |format|
      if @standard_size.save
        format.html { redirect_to @standard_size, notice: 'Standard size was successfully created.' }
        format.json { render :show, status: :created, location: @standard_size }
      else
        format.html { render :new }
        format.json { render json: @standard_size.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /standard_sizes/1
  # PATCH/PUT /standard_sizes/1.json
  def update
    respond_to do |format|
      if @standard_size.update(standard_size_params)
        format.html { redirect_to @standard_size, notice: 'Standard size was successfully updated.' }
        format.json { render :show, status: :ok, location: @standard_size }
      else
        format.html { render :edit }
        format.json { render json: @standard_size.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /standard_sizes/1
  # DELETE /standard_sizes/1.json
  def destroy
    @standard_size.destroy
    respond_to do |format|
      format.html { redirect_to standard_sizes_url, notice: 'Standard size was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

# Get Standard Size object based on fit type, neck and sleeve length
  def get_standard_size
    standard_size = StandardSize.where(fit_type: params[:fit_type]).where(neck: params[:neck]).where(shirt_length: params[:shirt_length])
    render json: standard_size.to_json, status: "200"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_standard_size
      @standard_size = StandardSize.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def standard_size_params
      params.require(:standard_size).permit(:fit_type, :neck, :chest, :waist, :bottom, :yoke, :biceps, :wrist, :shirt_length, :luxire_product_type_id)
    end
end
