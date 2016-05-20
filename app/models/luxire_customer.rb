class LuxireCustomer < ActiveRecord::Base
  belongs_to :spree_user, class_name: "Spree::User"
end
