class CustomizedActiveShippingSettingsController < Spree::Api::BaseController

  def initialize
    @path = 'spree/admin/promotions'
    @name = 'promotions'
  end

  def show
  @preferences_UPS = [:ups_login, :ups_password, :ups_key, :shipper_number]
  @preferences_FedEx = [:fedex_login, :fedex_password, :fedex_account, :fedex_key]
  @preferences_USPS = [:usps_login, :usps_commercial_base, :usps_commercial_plus]
  @preferences_CanadaPost = [:canada_post_login]
  @preferences_GeneralSettings = [:units, :unit_multiplier, :default_weight, :handling_fee,
    :max_weight_per_package, :test_mode]

  @config = Spree::ActiveShippingConfiguration.new
  render json: get_preference
end

def update
  @preferences_UPS = [:ups_login, :ups_password, :ups_key, :shipper_number]
  @preferences_FedEx = [:fedex_login, :fedex_password, :fedex_account, :fedex_key]
  @preferences_USPS = [:usps_login, :usps_commercial_base, :usps_commercial_plus]
  @preferences_CanadaPost = [:canada_post_login]
  @preferences_GeneralSettings = [:units, :unit_multiplier, :default_weight, :handling_fee,
    :max_weight_per_package, :test_mode]
  @config = Spree::ActiveShippingConfiguration.new

  params.each do |name, value|
    next unless @config.has_preference? name
    @config[name] = value
  end

render json: get_preference
end

def get_preference
  @preferences_setting = Hash.new(0)
  @preferences_UPS.each do |key|
    @preferences_setting[key] = @config[key]
  end
  @preferences_FedEx.each  do |key|
    @preferences_setting [key] = @config[key]
  end
  @preferences_USPS.each  do |key|
    @preferences_setting [key] = @config[key]
  end
  @preferences_CanadaPost.each  do |key|
    @preferences_setting [key] = @config[key]
  end
  @preferences_GeneralSettings.each  do |key|
    @preferences_setting [key] = @config[key]
  end
  @preferences_setting
end

end
