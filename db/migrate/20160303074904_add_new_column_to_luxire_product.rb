class AddNewColumnToLuxireProduct < ActiveRecord::Migration
  def change
  	 add_column :luxire_products, :stiffness, :decimal, precision: 5, scale: 2
	 add_column :luxire_products, :stiffness_unit, :string
	 add_column :luxire_products, :barcode, :string
	 add_column :luxire_products, :collection, :string
	 add_column :luxire_products, :no_of_color, :integer
	 add_column :luxire_products, :wash_care, :string
	 add_column :luxire_products, :gsm, :integer
	 add_column :luxire_products, :shrinkage, :decimal, precision: 5, scale: 2
	 add_column :luxire_products, :pitch_sales, :string
  end
end
