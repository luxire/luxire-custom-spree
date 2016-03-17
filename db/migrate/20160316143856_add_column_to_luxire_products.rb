class AddColumnToLuxireProducts < ActiveRecord::Migration
  def change
	 add_column :luxire_products, :length_required, :decimal, precision: 8, scale:2
        add_column :luxire_products, :usage, :string
        add_column :luxire_products, :mill, :string
        add_column :luxire_products, :country_of_origin, :string
        add_column :luxire_products, :glm, :decimal, precision: 8, scale:2
        add_column :luxire_products, :technical_description, :string
        add_column :luxire_products, :related_fabric, :string



  end
end
