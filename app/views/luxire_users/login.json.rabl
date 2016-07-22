object @User
if @User
  attributes :id, :email, :spree_api_key
  child (:spree_roles) do
    attributes :id, :name
  end
  child (:luxire_customer) do
    attributes :first_name, :last_name
  end
else
  node(:statusCode){ 401}
  node(:statusText){"Login Failed"}
end
# object @User
# attributes :id
#
# if @User
#   node(:statusCode){ 200}
#   node(:statusText){"Login Successful"}
# else
#   node(:statusCode){ 401}
#   node(:statusText){"Login Failed"}
# end
# node(:body){ User.id
#   # node (:userId){ |User| User.id}
# }
