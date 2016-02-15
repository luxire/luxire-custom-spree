class CreateProductMeasurementTypes < ActiveRecord::Migration
  def change
    create_table :product_measurement_types do |t|
      t.integer :luxire_product_type_id
      t.integer :measurement_type_id

      t.timestamps null: false
    end
  end
end
