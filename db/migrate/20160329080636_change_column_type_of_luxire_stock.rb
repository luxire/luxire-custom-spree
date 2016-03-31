class ChangeColumnTypeOfLuxireStock < ActiveRecord::Migration
  def change
	change_column :luxire_stocks, :virtual_count_on_hands, :decimal, precision: 8, scale: 2
	change_column :luxire_stocks, :physical_count_on_hands,:decimal, precision: 8, scale: 2
  end
end
