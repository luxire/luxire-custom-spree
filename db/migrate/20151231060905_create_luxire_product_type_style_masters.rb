class CreateLuxireProductTypeStyleMasters < ActiveRecord::Migration
  def change
    create_table :luxire_product_type_style_masters do |t|
      t.integer :luxire_product_type_id
      t.integer :luxire_style_master_id

      t.timestamps null: false
    end
  end
end
