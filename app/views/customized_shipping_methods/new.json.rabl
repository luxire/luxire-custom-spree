object @object
child @available_zones do
  attributes :id, :name, :description, :kind
  child (:zone_members) do
    attributes :id, :zoneable_id, :zoneable_type, :zone_id
  end
end

child @tax_categories do
  attributes :id, :name, :description, :tax_code, :is_default
end

node :calculators do
    @calculators.map { |c|
      {name: c.name,description: c.description}
    }
end
