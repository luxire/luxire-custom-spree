class CurrenciesController < ApplicationController
  before_action :set_currency, only: [:show, :edit, :update, :destroy]

  # GET /currencies
  # GET /currencies.json
  def index
    @currencies = Currency.all
  end

  # GET /currencies/1
  # GET /currencies/1.json
  def show
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
  end

  # GET /currencies/1/edit
  def edit
  end

  # POST /currencies
  # POST /currencies.json
  def create
    @currency = Currency.new(currency_params)

    respond_to do |format|
      if @currency.save
        format.html { redirect_to @currency, notice: 'Currency was successfully created.' }
        format.json { render :show, status: :created, location: @currency }
      else
        format.html { render :new }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /currencies/1
  # PATCH/PUT /currencies/1.json
  def update
    respond_to do |format|
      if @currency.update(currency_params)
        format.html { redirect_to @currency, notice: 'Currency was successfully updated.' }
        format.json { render :show, status: :ok, location: @currency }
      else
        format.html { render :edit }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.json
  def destroy
    @currency.destroy
    respond_to do |format|
      format.html { redirect_to currencies_url, notice: 'Currency was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

# Get current date currency multiplier and populate the database
  def populate_currency
    url = URI.parse('http://apilayer.net/api/live?access_key=a917a3d6244742e74dacea1ec2e29940&currencies=EUR,AUD,SGD,NOK,DKK,SEK,CHF,FIM,INR&source=USD&format=1')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
    http.request(req)
    }
    response_hash =  eval(res.body)
    currency_hash = {fetched_date: Date.new, value: response_hash[:quotes]}
    begin
    @currency = Currency.find(Date.new)
    rescue Exception
     logger.debug "No record available for the day"
    end

    if @currency
      @currency.value = response_hash[:quotes]
    else
      @currency = Currency.new(currency_hash)
    end

    respond_to do |format|
      if @currency.save
        format.html { redirect_to @currency, notice: 'Currency was successfully created.' }
        format.json { render json: @currency.to_json , status: "200" }
      else
        format.html { render :new }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

# def get the currency multiplier
    def get_currency_multiplier
# Get the current date
        date = Date.new
# Get the current time. This value is only used for logs
        t1 = Time.now
# Handle the ActiveRecord::NotFound exception
        begin
          @currency = Currency.find(date)
        rescue
          logger.debug "No currency multiplier value for " + Time.now.strftime("%m/%d/%Y")
        end

        unless @currency
          while(true)
            date = date - 1
            count = 1
            begin
              @currency = Currency.find(date)
            rescue
              t = t1 - count
              logger.debug "No currency multiplier value for " + t.strftime("%m/%d/%Y")
            end
            if @currency
              break;
            end
          end
        end
          render json: @currency.to_json, status: "200"
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def currency_params
      params.require(:currency).permit(:fetched_date, :value)
    end
end
