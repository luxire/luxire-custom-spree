class AddAttachmentImageToCustomImages < ActiveRecord::Migration
  def self.up
    change_table :custom_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :custom_images, :image
  end
end
