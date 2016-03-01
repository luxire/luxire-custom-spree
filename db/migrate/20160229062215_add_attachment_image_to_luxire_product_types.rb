class AddAttachmentImageToLuxireProductTypes < ActiveRecord::Migration
  def self.up
    change_table :luxire_product_types do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :luxire_product_types, :image
  end
end
