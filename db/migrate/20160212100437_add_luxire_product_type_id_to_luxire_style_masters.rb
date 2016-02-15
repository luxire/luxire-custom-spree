class AddLuxireProductTypeIdToLuxireStyleMasters < ActiveRecord::Migration
  def change
    add_column :luxire_style_masters, :luxire_product_type_id, :integer
  end
end
