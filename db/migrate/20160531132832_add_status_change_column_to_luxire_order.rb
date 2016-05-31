class AddStatusChangeColumnToLuxireOrder < ActiveRecord::Migration
  def self.up
	add_column :luxire_products, :status_changed_time, :timestamp
  end

def self.down
        remove_column :luxire_products, :status_changed_time
  end

end
