json.array!(@luxire_taxonomies) do |luxire_taxonomy|
  json.extract! luxire_taxonomy, :id, :mega_menu_template, :spree_taxonomy_id
  json.url luxire_taxonomy_url(luxire_taxonomy, format: :json)
end
