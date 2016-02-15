class CustomizedTaxCategoriesController < CustomizedResourceController
  def initialize
    @path = 'spree/admin/tax_categories'
    @name = 'tax_categories'
  end
end
