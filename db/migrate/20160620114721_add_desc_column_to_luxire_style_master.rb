class AddDescColumnToLuxireStyleMaster < ActiveRecord::Migration
  def self.up
	add_column :luxire_style_masters, :description, :string
  end

  def self.down
	remove_column :luxire_style_masters, :description
  end
end
