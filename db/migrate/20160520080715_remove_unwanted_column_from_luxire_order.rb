class RemoveUnwantedColumnFromLuxireOrder < ActiveRecord::Migration
  def self.up
	 remove_column :luxire_orders, :tax1_name
 remove_column :luxire_orders, :tax1_value
 remove_column :luxire_orders, :tax2_name
 remove_column :luxire_orders, :tax2_value
 remove_column :luxire_orders, :tax3_name
 remove_column :luxire_orders, :tax3_value
 remove_column :luxire_orders, :tax4_name
 remove_column :luxire_orders, :tax4_value
 remove_column :luxire_orders, :tax5_name
 remove_column :luxire_orders, :tax5_value
 remove_column :luxire_orders, :accepts_marketing
 remove_column :luxire_orders, :discount_code
 remove_column :luxire_orders, :vendor
 remove_column :luxire_orders, :tags
 add_column :luxire_orders, :is_inventory_deducted, :boolean, default: false
  end

  def self.down
  add_column :luxire_orders, :tax1_name, :string
 add_column :luxire_orders, :tax1_value, :decimal, precision: 8, scale: 2
 add_column :luxire_orders, :tax2_name, :string
 add_column :luxire_orders, :tax2_value, :decimal, precision: 8, scale: 2
 add_column :luxire_orders, :tax3_name, :string
 add_column :luxire_orders, :tax3_value, :decimal, precision: 8, scale: 2
 add_column :luxire_orders, :tax4_name, :string
 add_column :luxire_orders, :tax4_value, :decimal, precision: 8, scale: 2
 add_column :luxire_orders, :tax5_name, :string
 add_column :luxire_orders, :tax5_value, :decimal, precision: 8, scale: 2
 add_column :luxire_orders, :accepts_marketing, :boolean
 add_column :luxire_orders, :discount_code, :string
 add_column :luxire_orders, :vendor, :string
 add_column :luxire_orders, :tags, :string
  end
end
