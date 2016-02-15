class CustomizedTaxRatesController < CustomizedResourceController
  before_action :load_data

  def initialize
    @path = 'spree/admin/tax_rates'
    @name = 'tax_rates'
  end

def index
render json: @tax_rates
end
  private

  def load_data
    @available_zones = Spree::Zone.order(:name)
    @available_categories = Spree::TaxCategory.order(:name)
    @calculators = Spree::TaxRate.calculators.sort_by(&:name)
  end
end
