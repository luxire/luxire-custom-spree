class LuxireStocksController < Spree::Api::BaseController
  before_action :set_luxire_stock, only: [:show, :edit, :update, :destroy]

  # GET /luxire_stocks
  # GET /luxire_stocks.json
  def index
    @luxire_stocks = LuxireStock.all
  end

  # GET /luxire_stocks/1
  # GET /luxire_stocks/1.json
  def show
  end

  # GET /luxire_stocks/new
  def new
    @luxire_stock = LuxireStock.new
  end

  # GET /luxire_stocks/1/edit
  def edit
  end

  # POST /luxire_stocks
  # POST /luxire_stocks.json
  def create
    @luxire_stock = LuxireStock.new(luxire_stock_params)

    respond_to do |format|
      if @luxire_stock.save
        format.html { redirect_to @luxire_stock, notice: 'Luxire stock was successfully created.' }
        format.json { render :show, status: :created, location: @luxire_stock }
      else
        format.html { render :new }
        format.json { render json: @luxire_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luxire_stocks/1
  # PATCH/PUT /luxire_stocks/1.json
  def update
    respond_to do |format|
      if @luxire_stock.update(luxire_stock_params)
        format.html { redirect_to @luxire_stock, notice: 'Luxire stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @luxire_stock }
      else
        format.html { render :edit }
        format.json { render json: @luxire_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luxire_stocks/1
  # DELETE /luxire_stocks/1.json
  def destroy
    @luxire_stock.destroy
    respond_to do |format|
      format.html { redirect_to luxire_stocks_url, notice: 'Luxire stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


# add_stocks method allows admin to add a product to inventory
  def add_stocks
    get_luxire_stock
    
    @luxire_stock.virtual_count_on_hands += params[:luxire_stock][:count].to_i
    @luxire_stock.physical_count_on_hands += params[:luxire_stock][:count].to_i
    @luxire_stock.save
    render json: @luxire_stock, status: '200'
  end

# set_stocks method allows admin to set a product to inventory
  def set_stocks
    get_luxire_stock
    @luxire_stock.virtual_count_on_hands = params[:luxire_stock][:count]
    @luxire_stock.physical_count_on_hands = params[:luxire_stock][:count]
    @luxire_stock.save
    render json: @luxire_stock, status: '200'
  end

# validate_stocks_sku validates whether an parent_sku already exist or not
# If it exist returns true else return false
  def validate_stocks_sku
  stock = LuxireStock.where(parent_sku: params[:parent_sku])
  if stock.empty?
    res = {msg: "false"}
    render json: res.to_json, status: "200"
  else
    res	 = stock.first
    render json: res.to_json, status: "200"
  end
end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luxire_stock
      @luxire_stock = LuxireStock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luxire_stock_params
      params.require(:luxire_stock).permit(:stock_location_id, :parent_sku, :virtual_count_on_hands, :physical_count_on_hands, :measuring_unit, :backorderable, :deleted_at, :rack, :threshold)
    end

# get_luxire_stock method gets luxire_stock based on parent_sku
    def get_luxire_stock     
     sku = params[:luxire_stock][:parent_sku]
     @luxire_stock = LuxireStock.where(parent_sku: sku).first
   end

end
