class CreateLuxireTaxonomies < ActiveRecord::Migration
  def change
    create_table :luxire_taxonomies do |t|
      t.string :mega_menu_template
      t.integer :spree_taxonomy_id

      t.timestamps null: false
    end
  end
end
