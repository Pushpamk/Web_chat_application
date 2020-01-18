class UserNotifierMailer < ApplicationMailer
  default :from => 'no-reply@pushpam_zoli_api.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
          :subject => 'Thanks for signing up for our amazing Zoli Dating app :D' )
  end
end