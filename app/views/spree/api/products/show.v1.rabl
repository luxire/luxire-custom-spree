object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

# attributes *product_attributes

node(:display_price) { |p| p.display_price.to_s }


child :master => :master do
  # attributes *Master.column_names  - ["height", "width", "depth"]
  # attributes :images
  # attributes :images
  attributes :name, :price, :slug
  extends "spree/api/variants/small.v1.rabl"

end

child :variants => :variants do
  # attributes :slug
  extends "spree/api/variants/small.v1.rabl"
end



child @luxire_product_type_attributes_customize => :customization_attributes do
  attributes  :name, :value, :description, :image, :help, :help_url
 end

 child @luxire_product_type_attributes_personalize => :personalization_attributes do
   attributes  :name, :value, :description, :image, :help, :help_url
 end


  child @luxire_product_type_attributes_measuement_std => :standard_measurement_attributes do
    attributes  :name, :value, :description, :image, :help, :help_url
  end

  child @luxire_product_type_attributes_measuement_body => :body_measurement_attributes do
    attributes  :name, :value, :description, :image, :help, :help_url
  end

  child :luxire_style_masters => :luxire_style_masters do
    attributes  :name, :default_values, :image, :help
  end

  child :classifications => :classifications do
    attributes :taxon_id, :position
    child(:taxon) do
      extends "spree/api/taxons/show"
    end
  end

  child :luxire_stock => :luxire_stock do
    attributes  :virtual_count_on_hands
  end

  child :luxire_product => :luxire_product do
    attributes *LuxireProduct.column_names - ["created_at", "updated_at"]
  end



  child :luxire_vendor_master => :vendor_master do
    attributes :name
  end
