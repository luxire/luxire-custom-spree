Spree::Order.class_eval do
has_one :luxire_order, class_name: "LuxireOrder"
has_many :luxire_line_item, class_name: 'LuxireLineItem', through: :spree_line_items
accepts_nested_attributes_for :luxire_order
end
