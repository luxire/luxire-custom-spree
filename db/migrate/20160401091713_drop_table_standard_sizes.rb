class DropTableStandardSizes < ActiveRecord::Migration
  def change
	drop_table :standard_sizes
  end
end
