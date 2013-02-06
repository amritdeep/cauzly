ActionMailer::Base.raise_delivery_errors = false
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {  
  :address              => "cauzly.com",  
  :port                 => 25,  
  :domain               => "cauzly.com", 
  :user_name            => "mailhandler.cauzly",  # this smtp configuration uses postfix MTA 
  :password             => "kupeve2012@cauzly.com",
  :authentication       => "plain",  
  :enable_starttls_auto => false
}


ActionMailer::Base.default_url_options[:host] = "cauzly.com"
