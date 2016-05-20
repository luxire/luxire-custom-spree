class AddLengthRequiredToProductTypeAndRemoveFromLuxireProduct < ActiveRecord::Migration
  def change
	add_column :luxire_product_types, :length_required, :decimal, precision: 8, scale: 2
	remove_column :luxire_products, :length_required
  end
end
