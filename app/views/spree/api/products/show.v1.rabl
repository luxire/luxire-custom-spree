
object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

# attributes *product_attributes
node(:name) { |p| p.name }
node(:id) { |p| p.id }
node(:slug) { |p| p.slug }

node(:display_price) { |p| p.display_price}
node(:available_on) { |p| p.available_on }
node(:is_gift_card) { |p| p.is_gift_card }

child :master => :master do
  # attributes *Master.column_names  - ["height", "width", "depth"]
  # attributes :images
  # attributes :images
  attributes :id, :name, :price, :slug
  extends "spree/api/variants/small.v1.rabl"

end

child :variants => :variants do
  # attributes :slug
  extends "spree/api/variants/small.v1.rabl"
end


measurement_url = ENV['CDN'] + "luxire/images/measurement_type/"
child @luxire_product_type_attributes_customize => :customization_attributes do |product_type_attributes|
  attributes :id, :name, :value, :description, :help, :help_url
  node(:image) do |i|
    unless i.image_file_name.nil?
      "#{measurement_url}#{i.id}/small/#{i.image_file_name}"
    else
      ""
    end
  end
  node(:category) do |attr|
   'c'
  end
 end

 child @luxire_product_type_attributes_personalize => :personalization_attributes do |product_type_attributes|
   attributes :id,  :name, :value, :description,:help, :help_url
   node(:image) do |i|
     unless i.image_file_name.nil?
       "#{measurement_url}#{i.id}/small/#{i.image_file_name}"
     else
       ""
     end
   end
   node(:category) do |attr|
   'p'
  end
 end


  child @luxire_product_type_attributes_measuement_std => :standard_measurement_attributes do |product_type_attributes|
    attributes :id, :name, :value, :description,:help, :help_url
    node(:image) do |i|
      unless i.image_file_name.nil?
        "#{measurement_url}#{i.id}/small/#{i.image_file_name}"
      else
        ""
      end
    end
  end

  child @luxire_product_type_attributes_measuement_body => :body_measurement_attributes do |product_type_attributes|
    attributes  :id, :name, :value, :description, :help, :help_url
    node(:image) do |i|
      unless i.image_file_name.nil?
        "#{measurement_url}#{i.id}/small/#{i.image_file_name}"
      else
        ""
      end
    end
  end

  child :luxire_style_masters => :luxire_style_masters do
    attributes  :name, :default_values, :help, :description, :additional_cost
    image_url = ENV['CDN'] + "luxire/images/style_master/"
    node(:images) do |i|
    {small: "#{image_url}#{i.id}/small/#{i.image_file_name}", medium: "#{image_url}#{i.id}/medium/#{i.image_file_name}", large: "#{image_url}#{i.id}/large/#{i.image_file_name}"}
    end
    # child :image => :images do
	  #    urls = ["small","medium","large"]
  	# #Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
    # 	urls.each do |k|
    # 		url_name = "#{k}_url"
    # 		node(url_name) do |i|
    #       i.url(k)
    #     end
  	#   end
    # end
    node(:real_images) { |i| real_images(i)}
    node(:sketch_images) { |i| sketch_images(i)}
  end

  child :luxire_stock => :luxire_stock do
    attributes  :virtual_count_on_hands
  end

  child :luxire_product => :luxire_product do
    attributes *LuxireProduct.column_names - ["created_at", "updated_at"]
  end

child :taxons => :taxons do
    attributes :name,:permalink
  end

  child :luxire_vendor_master => :vendor_master do
    attributes :name
  end

  child :luxire_product_type => :product_type do
    attributes :product_type
    product_type = self.instance_variable_get(:@luxire_product_type).product_type
    if product_type == "Jackets"
      node(:pant_id) { get_pants_product_id }
      node(:vest_id) { get_vests_product_id } 
    end
  end
