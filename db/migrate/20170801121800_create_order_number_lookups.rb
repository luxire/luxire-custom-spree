class CreateOrderNumberLookups < ActiveRecord::Migration
  def change
    create_table :order_number_lookups do |t|
      t.integer :order_number
      t.string :spree_order_number

      t.timestamps null: false
    end
  end
end
