class CreateLuxireVendorMasters < ActiveRecord::Migration
  def change
    create_table :luxire_vendor_masters do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
