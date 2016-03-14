Spree::User.class_eval do
has_one :luxire_customer, class_name: "LuxireCustomer"
has_many :styles, class_name: "LuxireStyleMaster"
end
