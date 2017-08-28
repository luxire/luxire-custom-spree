class AddNotesToLuxireLineItem < ActiveRecord::Migration
  def change
    add_column :luxire_line_items, :notes, :string
  end
end
