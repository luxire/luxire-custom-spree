
object false # custom node, no explicit object

node :luxire_product_attributes do
node :customize do
  @luxire_product_type_attributes_customize.map do |stat| 
    { :name => stat.name, :value => stat.value }
  end
end

end
