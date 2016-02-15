class AddColumnToLuxireProduct < ActiveRecord::Migration
  def change
add_column :luxire_products, :luxire_stock_id, :integer
  end
end
