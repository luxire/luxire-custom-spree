Spree::User.class_eval do
has_one :luxire_customer, class_name: "LuxireCustomer", dependent: :destroy
has_many :styles, class_name: "LuxireStyleMaster"
has_many :luxire_orders, class_name: "LuxireOrder", through: :orders
end
