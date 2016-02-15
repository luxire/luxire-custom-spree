Spree::User.class_eval do
has_one :luxire_customer, class_name: "LuxireCustomer"
end
