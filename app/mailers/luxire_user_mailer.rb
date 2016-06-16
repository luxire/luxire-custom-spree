class LuxireUserMailer < ApplicationMailer
  default from: "mudassir@azureiken.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.luxire_user_mailer.password_reset.subject
  #
  def password_reset(user, raw_token, request)
    @user = user
    @user_raw_token = raw_token
    @domain = request.domain || request.remote_ip
    mail :to =>user.email, :subject =>"Password Reset"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.luxire_user_mailer.confirm_account.subject
  #
  def confirm_account(user)

    Rails.logger.debug "user is"+user.inspect
    @user = user
    # Rails.logger.debug "first_name "+@user.first_name
    mail :to =>user.email, :subject =>"Customer Account confirmation"
    @user = user
  end
end
