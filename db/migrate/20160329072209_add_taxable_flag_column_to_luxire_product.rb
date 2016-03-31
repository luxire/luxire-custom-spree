class AddTaxableFlagColumnToLuxireProduct < ActiveRecord::Migration
  def change
	 add_column :luxire_products, :variant_taxable, :boolean
	 add_column :luxire_products, :variant_require_shipping, :boolean
	 add_column :luxire_products, :variant_fulfillment_service, :string
	 add_column :luxire_products, :inventory_tracked_by, :string
  end
end
