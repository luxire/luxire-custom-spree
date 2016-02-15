object @User
if @User
  node(:statusCode){201}
  node(:statusText){"password change Successful"}
elsif @password_mismatch
  node(:statusCode){400}
  node(:statusText){"password mismatch"}
elsif @invalid_old_password
  node(:statusCode){401}
  node(:statusText){"unauthorised"}
elsif @user_does_not_exist
  node(:statusCode){404}
  node(:statusText){"user not found"}
end
