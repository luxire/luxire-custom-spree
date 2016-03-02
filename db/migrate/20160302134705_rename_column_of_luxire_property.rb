class RenameColumnOfLuxireProperty < ActiveRecord::Migration
  def change
    rename_column :luxire_properties, :product_type_id, :luxire_product_type_id
  end
end
