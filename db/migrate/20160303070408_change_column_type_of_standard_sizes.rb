class ChangeColumnTypeOfStandardSizes < ActiveRecord::Migration
  def change
   change_column :standard_sizes, :neck, :decimal, precision: 5, scale: 2
   change_column :standard_sizes, :chest, :decimal, precision: 5, scale: 2
   change_column :standard_sizes, :waist, :decimal, precision: 5, scale: 2
   change_column :standard_sizes, :bottom, :decimal, precision: 5, scale: 2
   change_column :standard_sizes, :yoke, :decimal, precision: 5, scale: 2
   change_column :standard_sizes, :biceps, :decimal, precision: 5, scale: 2
   change_column :standard_sizes, :wrist, :decimal, precision: 5, scale: 2
   change_column :standard_sizes, :shirt_length, :decimal, precision: 5, scale: 2
  end
end
