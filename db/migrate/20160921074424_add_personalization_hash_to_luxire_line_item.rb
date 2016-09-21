class AddPersonalizationHashToLuxireLineItem < ActiveRecord::Migration
  def change
    add_column :luxire_line_items, :total_personalisation_cost_in_currencies, :json
  end
end
