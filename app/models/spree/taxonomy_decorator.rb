Spree::Taxonomy.class_eval do
has_one :luxire_taxonomy, class_name: "LuxireTaxonomy", foreign_key: :spree_taxonomy_id
end
