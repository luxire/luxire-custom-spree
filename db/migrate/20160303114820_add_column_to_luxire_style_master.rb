class AddColumnToLuxireStyleMaster < ActiveRecord::Migration
  def change
	add_column :luxire_style_masters , :help, :string 
  end
end
