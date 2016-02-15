class CreateLuxireStocks < ActiveRecord::Migration
  def change
    create_table :luxire_stocks do |t|
      t.integer :stock_location_id
      t.string :parent_sku
      t.integer :virtual_count_on_hands
      t.integer :physical_count_on_hands
      t.string :measuring_unit
      t.boolean :backorderable
      t.datetime :deleted_at
      t.string :rack
      t.integer :threshold

      t.timestamps null: false
    end
  end
end
