object false

child @measurement_type_customize => :customization_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |p|
      {small: p.image(:small), medium: p.image(:medium)}
  end
end

child @measurement_type_personalize => :personalization_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |p|
      {small: p.image(:small), medium: p.image(:medium)}
  end
end

child @measurement_type_body_measurement => :body_measurement_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |p|
      {small: p.image(:small), medium: p.image(:medium)}
  end
end

child @measurement_type_std_measurement => :std_measurement_attributes do
  attributes :id, :name, :value, :description, :category , :sub_category, :help, :help_url
  node(:image) do |p|
      {small: p.image(:small), medium: p.image(:medium)}
  end
end
