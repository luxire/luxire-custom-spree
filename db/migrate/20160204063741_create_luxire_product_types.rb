class CreateLuxireProductTypes < ActiveRecord::Migration
  def change
    create_table :luxire_product_types do |t|
      t.string :product_type
      t.string :description

      t.timestamps null: false
    end
  end
end
