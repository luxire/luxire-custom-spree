json.array!(@currencies) do |currency|
  json.extract! currency, :id, :fetched_date, :value
  json.url currency_url(currency, format: :json)
end
