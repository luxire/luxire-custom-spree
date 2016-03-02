class RemovecolumnFromLuxireProperty < ActiveRecord::Migration
  def change
	remove_column :luxire_properties, :luxire_product_type_id
  end
end
