class CreateMeasurementTypePrototypes < ActiveRecord::Migration
  def change
    create_table :measurement_type_prototypes do |t|
      t.string :name
      t.string :value

      t.timestamps null: false
    end
  end
end
