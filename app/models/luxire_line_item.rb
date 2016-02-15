class LuxireLineItem < ActiveRecord::Base
	belongs_to :line_item, class_name: "Spree::LineItem"
end
