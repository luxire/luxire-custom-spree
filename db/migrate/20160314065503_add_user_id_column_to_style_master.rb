class AddUserIdColumnToStyleMaster < ActiveRecord::Migration
  def change
  	add_column :luxire_style_masters, :user_id, :integer
  end
end
