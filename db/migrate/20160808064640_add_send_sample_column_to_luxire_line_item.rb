class AddSendSampleColumnToLuxireLineItem < ActiveRecord::Migration
  def self.up
	add_column :luxire_line_items, :measurement_unit, :string
	add_column :luxire_line_items, :send_sample, :boolean, default: :false
  end

  def self.down
	remove_column :luxire_line_items, :measurement_unit	
	remove_column :luxire_line_items, :send_sample
  end
end
