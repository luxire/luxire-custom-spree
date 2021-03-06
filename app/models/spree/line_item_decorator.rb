Spree::LineItem.class_eval do
has_one :luxire_line_item, class_name: 'LuxireLineItem', dependent: :destroy
has_one :luxire_stock, class_name: 'LuxireStock', through: :product
has_one :luxire_product_type, class_name: 'LuxireProductType' , through: :product
# accepts_nested_attributes_for :luxire_line_item

def update_adjustments
  # byebug
    recalculate_adjustments
    update_tax_charge # Called to ensure pre_tax_amount is updated.
end

def formatted_total
  Spree::Money.new(total, { currency: currency })
end

end
