class CreateLuxireStyleMasterImages < ActiveRecord::Migration
  def change
    create_table :luxire_style_master_images do |t|
      t.string :category
      t.integer :luxire_style_master_id
      t.string :alternate_text
      t.attachment :image

      t.timestamps null: false
    end
  end
end
