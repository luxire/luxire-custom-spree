object @User
if @user_does_not_exist
  node(:statusCode){404}
  node(:statusText){"user does not exist"}
elsif @User
  node(:statusCode){201}
  node(:statusText){"user updated Successfully"}
end
