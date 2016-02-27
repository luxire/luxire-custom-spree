class AddColumnToLuxireLineItem < ActiveRecord::Migration
  def change
	add_column :luxire_line_items, :customized_data, :json
        add_column :luxire_line_items, :personalize_data, :json
        add_column :luxire_line_items, :measurement_data, :json
  end
end
