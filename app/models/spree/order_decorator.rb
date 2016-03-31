Spree::Order.class_eval do
has_one :luxire_order, class_name: "LuxireOrder"
has_many :luxire_line_items, class_name: 'LuxireLineItem', through: :line_items
accepts_nested_attributes_for :luxire_order
end
