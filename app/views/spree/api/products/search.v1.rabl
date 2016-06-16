object false
node(:count) { @products.count }
node(:total_count) { @products.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @products.num_pages }

child(@products => :products) do
  node(:id) { |p| p.id }
  node(:name) { |p| p.name }
  node(:slug) { |p| p.slug }

   # node(:images) {|p| p.master.images}

  # node :image do
  #   root_object.each do |product|
  #
  # product.master.images.each do |image|
  #   node(:large_url) { image.attachment.url("large")}
  # end
  # end


    #  variants = product.variants
    #  if variants
   # end
  # master = product.master
  child :master do
    child :images do
      Spree::Image.attachment_definitions[:attachment][:styles].each do |k,v|
        if "#{k}_url".casecmp("small_url") == 0
          node("#{k}_url") { |i| i.attachment.url(k) }
        end
      end
    end
  end

  child :luxire_product_type => :product_type do
    attributes :product_type
  end
end
