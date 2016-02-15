object @User
if @password_reset_success
  node(:statusCode){200}
  node(:statusText){"password reset Successful"}
else
  node(:statusCode){404}
  node(:statusText){"user not found"}
end
