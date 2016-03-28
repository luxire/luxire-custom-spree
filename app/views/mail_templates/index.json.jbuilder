json.array!(@mail_templates) do |mail_template|
  json.extract! mail_template, :id, :name, :subject, :content
  json.url mail_template_url(mail_template, format: :json)
end
