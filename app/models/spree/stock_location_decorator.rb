Spree::StockLocation.class_eval do
has_many :luxire_stock, class_name: "LuxireStock"
end
