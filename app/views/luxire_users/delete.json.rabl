object @delete_success
if @delete_success
  node(:statusCode){204}
  node(:statusText){"user delete Successful"}
elsif @user_not_found
  node(:statusCode){404}
  node(:statusText){"user not found"}
end
