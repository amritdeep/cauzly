class NewsLetterMailer < ActionMailer::Base
  default from: "Cauzly.com<noreply@cauzly.com>"

  def newsletter_email(user,newsletter)
    @user = user
    @newsletter = newsletter
    @url  = root_url
    mail(
      :to => user.email,
      :subject => "#{newsletter.subject}"
      
    )
  end  
end
