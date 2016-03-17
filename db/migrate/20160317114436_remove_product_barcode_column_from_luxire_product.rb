class RemoveProductBarcodeColumnFromLuxireProduct < ActiveRecord::Migration
  def change
	remove_column :luxire_products, :product_barcode
  end
end
