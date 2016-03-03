class AddColumnToMeasureType < ActiveRecord::Migration
  def change
	add_column :measurement_types, :help, :string
	add_column :measurement_types, :help_url, :string
  end
end
