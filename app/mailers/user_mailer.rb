class UserMailer < ActionMailer::Base
  default from: "Cauzly.com<noreply@cauzly.com>"

 def send_email_invitation(email,from,message)
    @email = email
    @user = User.find_by_id(from)
    @message = message
    @url  = new_user_registration_url
    mail(
      :to => email,
      :subject => "Invitation to join Cauzly.com"
      
    )
  end
end 