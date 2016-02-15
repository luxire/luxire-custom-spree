class CreateLuxireStyleMasters < ActiveRecord::Migration
  def change
    create_table :luxire_style_masters do |t|
      t.string :name
      t.json :default_values

      t.timestamps null: false
    end
  end
end
