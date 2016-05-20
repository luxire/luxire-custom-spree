class AddDisableFieldToGiftCard < ActiveRecord::Migration
  def change
	add_column :spree_gift_cards, :disable, :boolean, default: false, null: false
	add_column :spree_gift_cards, :disable_enable_notes, :text
  end
end
