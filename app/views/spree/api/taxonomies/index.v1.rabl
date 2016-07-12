object false
child(@taxonomies => :taxonomies) do
  extends "spree/api/taxonomies/show"

  child :luxire_taxonomy => :luxire_taxonomy do
    attributes :mega_menu_template
  end
  
end
node(:count) { @taxonomies.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @taxonomies.num_pages }
