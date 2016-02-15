object @User
if @User
attributes :id,:first_name,:last_name,:email,:addresses
else
node(:statusCode){404}
node(:statusText){"user not found"}
end
