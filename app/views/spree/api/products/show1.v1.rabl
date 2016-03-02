object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes :id,:name

child :luxire_vendor_master => :luxire_vendor_master do
attributes :id,:name
end

child :luxire_product_type => :luxire_product_type do
attributes :id,:product_type
end
