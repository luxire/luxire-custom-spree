object @object
child @available_zones do
  attributes :id, :name, :description, :kind
end

child @available_categories do
  attributes *Spree::TaxCategory.column_names
end

node :calculators do
    @calculators.map { |c|
      {name: c.name,description: c.description}
    }
end
