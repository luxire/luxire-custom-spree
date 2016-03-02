Spree::Product.class_eval do
      has_one :luxire_product, class_name: 'LuxireProduct', :dependent => :destroy
      has_one :luxire_vendor_master, class_name: 'LuxireVendorMaster' , through: :luxire_product
      has_one :luxire_product_type, class_name: 'LuxireProductType' , through: :luxire_product
      has_many :luxire_style_masters, class_name: "LuxireStyleMaster" , through: :luxire_product_type
      has_one :luxire_stock, class_name: "LuxireStock", through: :luxire_product
      has_many :standard_sizes, class_name: "StandardSize", through: :luxire_product_type

      accepts_nested_attributes_for :luxire_product
end
