class SearchController <  Spree::Api::BaseController
  respond_to :json
  def get_all_data
  @products = Spree::Product.all
  @orders = Spree::Order.all
  @customers = Spree::User.all
  @collection = Spree::Taxon.all
  end
end
