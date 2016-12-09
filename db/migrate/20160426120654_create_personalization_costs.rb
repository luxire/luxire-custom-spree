class CreatePersonalizationCosts < ActiveRecord::Migration
  def change
    create_table :personalization_costs do |t|
      t.decimal :cost, precision: 10, scale: 2
      t.integer :line_item_id

      t.timestamps null: false
    end
  end
end
