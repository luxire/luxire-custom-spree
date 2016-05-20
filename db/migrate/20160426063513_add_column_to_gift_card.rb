class AddColumnToGiftCard < ActiveRecord::Migration
  def self.up
     add_column :spree_gift_cards, :expiry_date, :timestamp
  end
  
  def self.down
     remove_column :spree_gift_cards, :expiry_date
  end
end
