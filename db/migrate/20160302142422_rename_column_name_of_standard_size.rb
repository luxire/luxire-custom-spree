class RenameColumnNameOfStandardSize < ActiveRecord::Migration
  def change
      	rename_column :standard_sizes, :product_type_id, :luxire_product_type_id
  end
end
