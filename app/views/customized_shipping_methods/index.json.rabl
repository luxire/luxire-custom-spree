object @shipping_methods
attributes :id, :name, :tracking_url, :calculator_name
child(:calculator) do
  attributes :id, :type
end
