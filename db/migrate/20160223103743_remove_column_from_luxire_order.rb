class RemoveColumnFromLuxireOrder < ActiveRecord::Migration
  def change
	remove_column :luxire_orders, :customized_data 
	remove_column :luxire_orders, :personalize_data
	remove_column :luxire_orders, :measurement_data
  end
end
