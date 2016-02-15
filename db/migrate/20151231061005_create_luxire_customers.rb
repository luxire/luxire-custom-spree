class CreateLuxireCustomers < ActiveRecord::Migration
  def change
    create_table :luxire_customers do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :accepts_marketing_flag
      t.boolean :is_tax_exempt
      t.string :customer_notes
      t.string :customer_tags
      t.string :customer_created_by
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
