Spree::User.class_eval do
has_one :luxire_customer, class_name: "LuxireCustomer", dependent: :destroy
has_many :styles, class_name: "LuxireStyleMaster"
has_many :luxire_orders, class_name: "LuxireOrder", through: :orders
has_many :unique_addresses, -> { where(deleted_at: nil).select("DISTINCT ON (firstname, lastname, address1, address2, city, zipcode, state_name, state_id, country_id) *")  }, class_name: Spree::Address
end
