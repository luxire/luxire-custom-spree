class CreateStandardSizes < ActiveRecord::Migration
  def change
    create_table :standard_sizes do |t|
      t.string :fit_type
      t.integer :neck
      t.integer :chest
      t.integer :waist
      t.integer :bottom
      t.integer :yoke
      t.integer :biceps
      t.integer :wrist
      t.integer :shirt_length
      t.integer :product_type_id

      t.timestamps null: false
    end
  end
end
