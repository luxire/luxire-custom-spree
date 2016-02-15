class LuxireOrder < ActiveRecord::Base
  belongs_to :order, class_name: "Spree::Order"	
end
