object @object
attributes :id , :description , :expires_at , :starts_at , :name , :type , :usage_limit , :match_policy , :code , :advertise , :path , :created_at , :updated_at , :promotion_category_id , :credits_count , :promotion_rules

child  :promotion_actions do
  attributes :id , :promotion_id , :calculator
end
