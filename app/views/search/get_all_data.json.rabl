child @products do
  attributes :id, :name, :description, :price, :total_on_hand
  child :master => :master do
    child :images => :images do
      Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
        if k.to_s == "mini"
          node("#{k}_url") { |i| i.attachment.url(k) }
        end
      end
    end
  end
  child :luxire_product => :luxire_product do
    attributes :product_tags, :product_color
  end
end
child @orders do
  attributes :id, :number, :display_total, :user_id, :email, :payment_state, :shipment_state
  child :line_items => :line_items do
    child :product => :product do
      attributes :id, :name
      child :master => :master do
        child :images => :images do
          Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
            node("#{k}_url") { |i| i.attachment.url(k) }
          end
        end
      end
    end
  end
end
child @customers do
  attributes :id, :email, :shipping_address, :billing_address
  child :luxire_customer => :luxire_customer do
    attributes :first_name, :last_name, :customer_notes, :customer_tags
  end
  child :orders => :orders do
    attributes :number
  end
end
child @collection do
  attributes :id, :name
  child :products => :products do
    attributes :id, :name
  end

end
