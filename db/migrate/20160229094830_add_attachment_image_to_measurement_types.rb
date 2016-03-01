class AddAttachmentImageToMeasurementTypes < ActiveRecord::Migration
  def self.up
    change_table :measurement_types do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :measurement_types, :image
  end
end
