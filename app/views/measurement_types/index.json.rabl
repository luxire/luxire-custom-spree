object false
measurement_url = ENV['CDN'] + "luxire/images/measurement_type/"
child @measurement_type_customize => :customization_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |i|
    unless i.image_file_name.nil?
      {small: "#{measurement_url}#{i.id}/small/#{i.image_file_name}", medium: "#{measurement_url}#{i.id}/medium/#{i.image_file_name}"}
    else
      {small: "", medium: ""}
    end
  end
end

child @measurement_type_personalize => :personalization_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |i|
    unless i.image_file_name.nil?
      {small: "#{measurement_url}#{i.id}/small/#{i.image_file_name}", medium: "#{measurement_url}#{i.id}/medium/#{i.image_file_name}"}
    else
      {small: "", medium: ""}
    end
  end
end

child @measurement_type_body_measurement => :body_measurement_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |i|
    unless i.image_file_name.nil?
      {small: "#{measurement_url}#{i.id}/small/#{i.image_file_name}", medium: "#{measurement_url}#{i.id}/medium/#{i.image_file_name}"}
    else
      {small: "", medium: ""}
    end
  end
end

child @measurement_type_std_measurement => :std_measurement_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |i|
    unless i.image_file_name.nil?
      {small: "#{measurement_url}#{i.id}/small/#{i.image_file_name}", medium: "#{measurement_url}#{i.id}/medium/#{i.image_file_name}"}
    else
      {small: "", medium: ""}
    end
  end
end
