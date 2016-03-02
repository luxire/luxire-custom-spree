class CreateLuxireProperties < ActiveRecord::Migration
  def change
    create_table :luxire_properties do |t|
      t.string :name
      t.string :value
      t.integer :product_type_id

      t.timestamps null: false
    end
  end
end
