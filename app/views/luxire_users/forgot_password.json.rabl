object @User
if @user_does_not_exist
  node(:statusCode){404}
  node(:statusText){"user does not exist"}
elsif @mail_delivery_succesful
  node(:statusCode){200}
  node(:statusText){"Mail delivery successful"}
elsif @mail_delivery_failed
  node(:statusCode){403}
  node(:statusText){"Mail delivery failed"}
end
