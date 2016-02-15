class AddSubCategoryToMeasurementTypes < ActiveRecord::Migration
  def change
    add_column :measurement_types, :sub_category, :string
  end
end
