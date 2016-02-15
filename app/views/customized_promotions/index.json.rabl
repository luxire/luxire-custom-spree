object @promo
attributes :id , :description , :expires_at , :starts_at , :name , :type , :usage_limit , :match_policy , :code , :advertise , :path , :created_at , :updated_at , :promotion_category_id , :credits_count

child :promotion_rules do
  attributes :id, :promotion_id, :user_id, :product_group_id, :type, :preferences
end

child  :promotion_actions do
  attributes :id , :promotion_id , :type, :calculator
end
