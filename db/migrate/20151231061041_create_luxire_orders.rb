class CreateLuxireOrders < ActiveRecord::Migration
  def change
    create_table :luxire_orders do |t|
      t.string :fulfillment_status
      t.datetime :fulfilled_at
      t.string :fulfilled_at_zone
      t.boolean :accepts_marketing
      t.string :discount_code
      t.string :vendor
      t.integer :order_id
      t.string :tags
      t.string :source
      t.string :tax1_name
      t.float :tax1_value
      t.string :tax2_name
      t.float :tax2_value
      t.string :tax3_name
      t.float :tax3_value
      t.string :tax4_name
      t.float :tax4_value
      t.string :tax5_name
      t.float :tax5_value
      t.json :customized_data
      t.json :personalize_data
      t.json :measurement_data
      t.string :notes_attributes

      t.timestamps null: false
    end
  end
end
