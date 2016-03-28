class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates do |t|
      t.string :name
      t.string :subject
      t.text :content

      t.timestamps null: false
    end
  end
end
