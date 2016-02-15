class CreateLuxireLineItems < ActiveRecord::Migration
  def change
    create_table :luxire_line_items do |t|
      t.string :fulfillment_status
      t.integer :line_item_id

      t.timestamps null: false
    end
  end
end
