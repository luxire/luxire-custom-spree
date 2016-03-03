object false

child @measurement_type_customize => :measurement_type_customize do
  attributes :id, :name, :value, :description, :category , :sub_category, :image
end

child @measurement_type_personalize => :measurement_type_personalize do
  attributes :id, :name, :value, :description, :category , :sub_category, :image
end

child @measurement_type_body_measurement => :measurement_type_body_measurement do
  attributes :id, :name, :value, :description, :category , :sub_category, :image
end

child @measurement_type_std_measurement => :measurement_type_std_measurement do
  attributes :id, :name, :value, :description, :category , :sub_category, :image
end
