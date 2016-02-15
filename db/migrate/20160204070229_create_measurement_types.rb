class CreateMeasurementTypes < ActiveRecord::Migration
  def change
    create_table :measurement_types do |t|
      t.string :name
      t.json :value
      t.string :description

      t.timestamps null: false
    end
  end
end
