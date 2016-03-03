json.array!(@luxire_style_masters) do |luxire_style_master|
  json.extract! luxire_style_master, :id, :name, :default_values, :image
 # json.url luxire_style_master_url(luxire_style_master, format: :json)
end
