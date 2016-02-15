object @User
if @token_expired
  node(:statusCode){408}
  node(:statusText){"token expired"}
elsif @valid_token
  node(:statusCode){200}
  node(:statusText){"valid token"}
elsif @user_does_not_exist
  node(:statusCode){404}
  node(:statusText){"user not found"}
end
