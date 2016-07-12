class AddPostionToProductMeasurementTypes < ActiveRecord::Migration
  def self.up
    add_column :product_measurement_types, :position, :integer
  end

  def self.down
    remove_column :product_measurement_types, :position
  end
end
