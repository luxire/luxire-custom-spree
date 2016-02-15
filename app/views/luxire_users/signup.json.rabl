object @response
if @user_created
  node(:statusCode){201}
  node(:statusText){"user created"}
  node(:user_id){@user_id_created}
elsif @unprocessible_entity
  node(:statusCode){422}
  node(:statusText){"Unprocessible entity"}
elsif @user_exists
  node(:statusCode){403}
  node(:statusText){"user exists"}
  # node(:response){@user_exists}
elsif @user_creation_failed
  node(:statusCode){500}
  node(:statusText){"user creation failed"}
end
