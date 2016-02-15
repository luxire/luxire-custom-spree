class CustomizedPromotionsController <  CustomizedResourceController
  before_action :load_data

  helper 'spree/promotion_rules'

  def initialize
    @path = 'spree/admin/promotions'
    @name = 'promotions'
  end

  def index
    @promo = collection
  end

  protected
    def location_after_save
      spree.edit_admin_promotion_url(@promotion)
    end

    def load_data
      @calculators = Rails.application.config.spree.calculators.promotion_actions_create_adjustments
      @promotion_categories = Spree::PromotionCategory.order(:name)
    end

    def collection
      return @collection if defined?(@collection)
      params[:q] ||= HashWithIndifferentAccess.new
      params[:q][:s] ||= 'id desc'

      @collection = super
      @search = @collection.ransack(params[:q])
      @collection = @search.result(distinct: true).
        includes(promotion_includes).
        page(params[:page]).
        per(params[:per_page] || Spree::Config[:promotions_per_page])

      @collection
    end

    def promotion_includes
      [:promotion_actions]
    end
end
