class AddAttachmentImageToLuxireStyleMasters < ActiveRecord::Migration
  def self.up
    change_table :luxire_style_masters do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :luxire_style_masters, :image
  end
end
