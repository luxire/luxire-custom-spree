class AddThreeColumnToLuxireProduct < ActiveRecord::Migration
  def change
     add_column :luxire_products, :global_upc, :string
     add_column :luxire_products, :global_isbn, :string
     add_column :luxire_products, :global_jan, :string
     add_column :luxire_products, :global_ean, :string     
  end
end
