class AddAdditionalCostToStyleMaster < ActiveRecord::Migration
  def change
    add_column :luxire_style_masters, :additional_cost, :json
  end
end
