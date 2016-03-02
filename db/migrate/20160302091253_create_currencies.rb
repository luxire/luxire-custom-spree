class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies, id: false do |t|
      t.date :fetched_date, primary_key: true
      t.json :value

      t.timestamps null: false
    end
  end
end
