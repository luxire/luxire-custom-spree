class AddColumnPositionToLuxireProductTypeStyleMaster < ActiveRecord::Migration
  def change
    add_column :luxire_style_masters, :position, :integer
  end
end
