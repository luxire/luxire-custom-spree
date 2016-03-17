class AddColumnToLuxireStock < ActiveRecord::Migration
  def change
	  add_column :luxire_stocks, :fabric_width, :decimal, precision: 8, scale:2
  end
end
