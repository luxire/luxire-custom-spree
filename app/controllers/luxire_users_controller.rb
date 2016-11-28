class LuxireUsersController < ApplicationController
  respond_to  :json, :html
  ##Login
  #curl command: curl -d "user[email]=spree@example.com&user[password]=spree123" -X POST http://localhost:3000/luxire-users/login
  ###
  def login
    user = luxire_auth(params[:user][:email], params[:user][:password])
    if user
      @User = user
      logger.debug "Login Successful"
      old_current, new_current = @User.current_sign_in_at, Time.now.utc
      @User.last_sign_in_at     = old_current || new_current
      @User.current_sign_in_at  = new_current
      old_current, new_current = @User.current_sign_in_ip, params[:userIp]
      @User.last_sign_in_ip     = old_current || new_current
      @User.current_sign_in_ip  = new_current
      @User.sign_in_count ||= 0
      @User.sign_in_count +=1
	if @User.save()
	   guest_token = Base64.decode64(request.cookies["guest_token"].split('--')[0])[1..22]
	 # guest_token = cookies.signed[:guest_token]
       @guest_order = Spree::Order.where(guest_token: guest_token, completed_at: nil, user_id: nil).last
       if @guest_order
         @guest_order.associate_user!(Spree::User.find(user.id))
       end
     end
    else
      logger.debug "Login Failed"
    end
  end

  #Signup
  #curl command: curl -d "user[email]=spree@example.com&user[password]=spree123&user[password_confirmation]=spree123" -X POST http://localhost:3000/luxire-users/signup
  # curl -d "user[first_name]=Mudassir&user[last_name]=23&user[email]=mudassir@azureiken.com&user[password]=spree123&user[password_confirmation]=spree123&user[spree_role_ids][]=1&user[spree_role_ids][]=2" -X POST http://localhost:3000/luxire-users/signup
  #
  def signup
    user = Spree::User.find_by_login(params[:user][:email])
    if user
      @user_exists = {"statusCode" => "403","statusText" => "user exists"}
      logger.debug "User already exists"
    else
      if params[:user][:email] && (params[:user][:password] == params[:user][:password_confirmation])
        user_created = Spree::User.new(:email => params[:user][:email],
                                            :password => params[:user][:password],
                                            :password_confirmation =>params[:user][:password_confirmation],
                                            :spree_role_ids => (params[:user][:spree_role_ids] && params[:user][:spree_role_ids].length > 0) ? params[:user][:spree_role_ids] : [2])
        user_created.build_luxire_customer
        user_created.luxire_customer.first_name = params[:user][:first_name] if params[:user][:first_name]
        user_created.luxire_customer.last_name = params[:user][:last_name] if params[:user][:last_name]
        if user_created.save
          user_created.generate_spree_api_key!
          logger.debug "User created with ID"
          logger.debug user_created[:id]
          logger.debug user_created.inspect
          LuxireUserMailer.confirm_account(user_created).deliver_now
          @user_id_created = user_created[:id]
          @user_created = {"statusCode" => "201","statusText" => "user created","user_id" => user_created[:id] }
          # LuxireUserMailer.confirm_account(user_created).deliver_now
        else
          @user_creation_failed = {"statusCode" => "500","statusText" => "User creation failed"}
        end
      else
        @unprocessible_entity = {"statusCode" => "422","statusText" => "Password Mismatch"}
      end
    end
  end

  #show- repond with user atrributes of requested user_id
  #curl http://localhost:3000/luxire-users/:id
  #

  def show
    if Spree::User.exists?(params[:id])
      @User = Spree::User.find(params[:id])
    else
      @user_not_found = {"statusCode" => "404","statusText" => "user not found"}
    end
    logger.debug " Mudassir "
  end
  ###
  #
  def show_by_role
  end

  ##Update
  # curl command: curl -d "user[first_name]=Mudassir&user[last_name]=H" -X PUT http://localhost:3000/luxire-users/1/edit
  #
  def update
    if Spree::User.exists?(params[:id])
      user = Spree::User.find(params[:id])
      logger.debug "user"

      logger.debug user.luxire_customer[:first_name]
      logger.debug "end"

      # user.luxire_customer.first_name = params[:user][:first_name] if params[:user][:first_name]
      # user.luxire_customer.last_name = params[:user][:last_name] if params[:user][:last_name]
      # user.first_name = params[:user][:first_name]
      # user.last_name = params[:user][:last_name]
      user.save
      @User = user
    else
      @user_does_not_exist = true
    end
  end

  ##Change password
  #curl command: curl -d "user[old_password]=spree123&user[new_password]=Azureiken123&user[new_password_confirmation]=Azureiken123" -X PUT http://localhost:3000/luxire-users/6/edit/change_password

  def change_password
    logger.debug "Changing password"
    if Spree::User.exists?(params[:id])
      user = Spree::User.find(params[:id])
      if user.valid_password?(params[:user][:old_password])
        if (params[:user][:new_password] == params[:user][:new_password_confirmation])
          user.reset_password!(params[:user][:new_password],params[:user][:new_password_confirmation])
          @User = user
        else
          @password_mismatch = true
        end
      else
        @invalid_old_password = true
      end
    else
      @user_does_not_exist = true
    end
  end

  #Forgot password
  #curl command: curl -d "user[email]=mudassir@azureiken.com" -X POST http://localhost:3000/luxire-users/forgot_password

  def forgot_password
    logger.debug "Forgot password"
    logger.debug params[:user][:email]
    user = Spree::User.find_by_email(params[:user][:email])
    if user.present?
        raw_token, enc = Devise.token_generator.generate(user.class, :reset_password_token)
        user.reset_password_token = enc
        user.reset_password_sent_at = Time.now.utc
        user.save!
        LuxireUserMailer.password_reset(user, raw_token, request).deliver_now
    else
      @user_does_not_exist =true
    end
  end

  #reset password validation
  #curl command:curl http://localhost:3000/password_reset/:token

  def reset_password_token_validation
    user = Spree::User.with_reset_password_token(params[:token])
    logger.debug user.inspect
    if user
      if user.reset_password_sent_at < 2.hours.ago ##reset token created 2 hours ago
        @token_expired = true
        logger.debug "token expired"
      else
        @valid_token = true
        logger.debug "valid token"
      end
      @user_exists = true
    elsif
      logger.debug "user not found"
      @user_does_not_exist = true
    end
  end

  #change password with reset token
  #curl command: curl -d "new_password=spree123&new_password_confirmation=spree123" -X POST http://localhost:3000/password_reset/3jUV6XTYztn75kktZSFx
  #curl -d "new_password=spree123&new_password_confirmation=spree123" -X POST http://localhost:3000/password_reset/:token

  def change_password_with_reset_token
    user = Spree::User.with_reset_password_token(params[:token])
    if user
      user.reset_password!(params[:new_password],params[:new_password_confirmation])
      user.reset_password_token = nil
      user.reset_password_sent_at = nil
      user.save
      @password_reset_success = true
    else
      @password_reset_failed = true
    end
  end

  ##delete
  #curl command:curl -X DELETE http://localhost:3000/luxire-users/:id
  def delete
    if Spree::User.exists?(params[:id])
      Spree::User.destroy(params[:id])
      @delete_success = true
    else
      @user_not_found = true
    end
  end

  #index- repond with user atrributes of allusers
  #curl http://localhost:3000/luxire-users
  #

  def index
    @User = Spree::User.all
  end

  #Return user by Role

  def usersByRole
    if Spree::Role.where(:name => params[:role]).empty? == false
      case params[:role]
        when "admin"
          @User = Spree::User.admin
        when "customer"
          @User = Spree::User.customer
        when "back_office_representative"
          @User = Spree::User.back_office_representative
        when "back_office_personnel"
          @User = Spree::User.back_office_personnel
        end
    elsif
      @User = false
    end
  end

  # #confirm-account
  # #curl
  # def account_confirm
  # end


  def contact_us
    name = params[:name]
    email = params[:email]
    order_number = params[order_number]
    message = params[:message]
    begin
      LuxireUserMailer.contact_us(name,email,order_number,message).deliver_now
      response = {msg: "Mail sent successfully"}
      render json: response.to_json, status: "200"
    rescue Exception => e
      response = {msg: e.message}
      render json: response.to_json, status: "500"
    end
  end

  private

  def luxire_auth(email, password)
    user = Spree::User.find_by_login(email)
    if user && user.valid_password?(password)
      user
    else
      false
    end
  end
end

#login
# logger.debug "Login user with id: "+params[:user][:email]
# user = Spree::User.find_by_login(params[:user][:email])
# if user && user.valid_password?(params[:user][:password])
#   @User = user
#   logger.debug "Login Successful"
#   old_current, new_current = @User.current_sign_in_at, Time.now.utc
#   @User.last_sign_in_at     = old_current || new_current
#   @User.current_sign_in_at  = new_current
#   old_current, new_current = @User.current_sign_in_ip, params[:userIp]
#   @User.last_sign_in_ip     = old_current || new_current
#   @User.current_sign_in_ip  = new_current
#   @User.sign_in_count ||= 0
#   @User.sign_in_count += 1
#   @User.save()
# else
#   logger.debug "Login Failed"
# end
# logger.debug raw
# logger.debug enc
# x = Spree::User.find_by_reset_password_token("a043f07636ad2fa3982e8245189f8189c1f05e16889e1cb8c24cad354843e64b").inspect
# logger.debug "start"
# logger.debug x
# logger.debug "end"
# if LuxireUserMailer.password_reset(user, raw_token).deliver
#   @mail_delivery_succesful = true
# else
#   @mail_delivery_failed = true
# end
