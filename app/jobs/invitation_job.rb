class InvitationJob < Struct.new(:email,:from,:message)
   def perform
    
       
         
           UserMailer.send_email_invitation(email,from,message).deliver
          #  puts "sentmail to : " + invitation_email['email']+"***"
    
   end
end