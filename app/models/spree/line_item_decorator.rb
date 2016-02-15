Spree::LineItem.class_eval do
has_one :luxire_line_item, class_name: 'LuxireLineItem'
accepts_nested_attributes_for :luxire_line_item
end
