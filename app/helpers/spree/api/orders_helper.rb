module Spree
  module Api
    module OrdersHelper

      def get_product_type_details(order)
        product_types = Hash.new(0)
        product_types_string = ""
        order.line_items.each do |line_item|
          if line_item.variant.sku.upcase.include?("SWT")
               if product_types["Swatch"].nil?
                  product_types["Swatch"] = line_item.quantity
               else
                  product_types["Swatch"] = product_types["Swatch"] + line_item.quantity
               end
          else
              luxire_product_type = line_item.luxire_product_type
              if(luxire_product_type && luxire_product_type.product_type)
                 pt = luxire_product_type.product_type.to_sym
                 if product_types[pt].nil?
                     product_types[pt] = line_item.quantity
                 else
                     product_types[pt] = product_types[pt] + line_item.quantity
                 end
              end
          end
        end
          product_types.keys.each do |product_type_key|
            product_types_string << "#{product_types[product_type_key]}#{product_type_key},"
          end
          product_types_string[0,product_types_string.length-1]
      end
    end
  end
end
