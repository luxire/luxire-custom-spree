class CreateCustomImages < ActiveRecord::Migration
  def change
    create_table :custom_images do |t|
      t.string :source

      t.timestamps null: false
    end
  end
end
