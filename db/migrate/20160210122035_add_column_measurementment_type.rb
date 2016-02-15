class AddColumnMeasurementmentType < ActiveRecord::Migration
  def change
add_column :measurement_types, :category, :string
  end
end
