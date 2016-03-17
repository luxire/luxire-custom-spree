class RemoveCollectionColumnFromLuxireProduct < ActiveRecord::Migration
  def change
    remove_column :luxire_products, :collection
  end
end
