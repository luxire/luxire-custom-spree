class CreateStandardSizes < ActiveRecord::Migration
  def change
    create_table :standard_sizes do |t|
      t.string :fit_type
      t.decimal :neck, precision: 5, scale: 2
      t.decimal :chest, precision: 5, scale: 2
      t.decimal :waist, precision: 5, scale: 2
      t.decimal :bottom, precision: 5, scale: 2
      t.decimal :yoke, precision: 5, scale: 2
      t.decimal :biceps, precision: 5, scale: 2
      t.decimal :wrist, precision: 5, scale: 2
      t.decimal :shirt_length, precision: 5, scale: 2
      t.integer :luxire_product_type_id

      t.timestamps null: false
    end
  end
end
