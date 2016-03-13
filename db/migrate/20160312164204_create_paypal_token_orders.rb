class CreatePaypalTokenOrders < ActiveRecord::Migration
  def change
    create_table :paypal_token_orders do |t|
      t.string :token
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
