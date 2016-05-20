class AddTotalPersonalizationCostToLuxireLineItem < ActiveRecord::Migration
  def self.up
  	add_column :luxire_line_items, :total_personalization_cost, :decimal, precision: 8, scale: 2
  end
  
  def self.down
  	remove_column :luxire_line_items, :total_personalization_cost
  end
end
