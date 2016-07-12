class LuxireTaxonomy < ActiveRecord::Base
  belongs_to :spree_taxonomy, class_name: "Spree::Taxonomy"
end
