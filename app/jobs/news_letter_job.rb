class NewsLetterJob < Struct.new(:news_letter)
   def perform
     if news_letter.user_type_id == 0
       #puts "processed"
       User.where("user_type_id != 1").each { |u| 
        # puts "sentmail to : " + u.email+"***"
         NewsLetterMailer.newsletter_email(u, news_letter).deliver
          }
      else
       # puts "unprocessed"
        User.where("user_type_id = ?",news_letter.user_type_id).each { |u|
         # puts "sentmail to : " + u.email+"***"
           NewsLetterMailer.newsletter_email(u, news_letter).deliver
           }
      end   
   end
end