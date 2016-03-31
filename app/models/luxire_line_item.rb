class LuxireLineItem < ActiveRecord::Base
	belongs_to :line_item, class_name: "Spree::LineItem"
	has_one :spree_order, class_name: "Spree::Order", through: :line_item
end
