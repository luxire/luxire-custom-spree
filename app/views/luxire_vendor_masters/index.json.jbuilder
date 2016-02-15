json.array!(@luxire_vendor_masters) do |luxire_vendor_master|
  json.extract! luxire_vendor_master, :id, :name
  json.url luxire_vendor_master_url(luxire_vendor_master, format: :json)
end
