class AddNewColumnToLuxireInventory < ActiveRecord::Migration
  def change
	add_column :luxire_stocks, :in_house, :boolean
  end
end
