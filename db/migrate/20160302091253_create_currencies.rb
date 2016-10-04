class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies, id: false do |t|
      t.date :fetched_date
      t.json :value
      t.timestamps null: false
    end
    execute "ALTER TABLE currencies ADD PRIMARY KEY (fetched_date);"
  end
end
