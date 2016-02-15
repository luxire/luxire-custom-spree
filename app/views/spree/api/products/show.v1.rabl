object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes *product_attributes

node(:display_price) { |p| p.display_price.to_s }
node(:has_variants) { |p| p.has_variants? }
node(:taxon_ids) { |p| p.taxon_ids }

child :master => :master do
  extends "spree/api/variants/small"
end

child :variants => :variants do
  extends "spree/api/variants/small"
end

#child :option_types => :option_types do
 # attributes *option_type_attributes
#end

#child :product_properties => :product_properties do
 # attributes *product_property_attributes
#end

#child :luxire_product => :luxire_product do
#attributes *luxire_product_attributes

#end

child :luxire_product_type => :luxire_product_type do
attributes *LuxireProductType.column_names - ["created_at", "updated_at"]
#child :measurement_types => :luxire_measurement_types do
#attributes *MeasurementType.column_names - ["created_at", "updated_at"]
#end

end

child @luxire_product_type_attributes_customize => :customization_attributes do
  attributes :id, :name, :value
 end

 child @luxire_product_type_attributes_personalize => :personalization_attributes do
  attributes :id, :name, :value
 end

# node @luxire_product_type_attributes_measurement => :luxire_product_attributes do |m| 
  #attributes :id, :name, :value
#  Rails.logger.debug "value check #{m}"
# end


  child @luxire_product_type_attributes_measuement_std => :measurement_std_attributes do 
   attributes :id, :name, :value
  end

  child @luxire_product_type_attributes_measuement_body => :measurement_body_attributes do
   attributes :id, :name, :value
  end




child :luxire_style_masters => :luxire_style_masters do
#  style_attributes = LuxireStyleMaster.column_names
#  style_attributes.map! {|style| style.to_sym}
#  attributes style_attributes
attributes *LuxireStyleMaster.column_names
end

child :luxire_vendor_master => :luxire_vendor_master do
  attributes *luxire_vendor_master_attributes
end

child :classifications => :classifications do
  attributes :taxon_id, :position

  child(:taxon) do
    extends "spree/api/taxons/show"
  end
end

child :luxire_stock => :luxire_stock do
attributes :id, :stock_location_id, :parent_sku, :virtual_count_on_hands, :physical_count_on_hands, :measuring_unit, :backorderable, :deleted_at, :rack, :threshold
end
