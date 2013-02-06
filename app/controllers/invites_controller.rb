class InvitesController < ApplicationController
  before_filter :require_login
  layout 'userprofile'
  
  def index
    if !current_user.authentications.blank?
   # @oauth_token=Authentication.where("provider='facebook'").first.token
      @oauth_token = current_user.authentications.where("provider='facebook'").first.token
    @rest = Koala::Facebook::API.new(@oauth_token)
    @friends = @rest.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid1 = me())")
     @cauzly_uids = Authentication.where("provider='facebook'").collect {|u| u.uid}.join ', '
     @cauzly_friends =  @rest.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid2 in (#{@cauzly_uids}) and uid1 = me())")
   end
  end
  
  
  def invite_email
    if request.xhr?
    emails = params[:email].delete_if{|x| x.blank?}
   message = "Hi,<br /> I would like to invite you to join cauzly.com"
   if !params[:message].blank?
     message = params[:message]
   end
    emails= emails.uniq
       if emails.blank?
         @msg= "Please provide at least one email"
         @status = false
       else
         @status = true
         @msg = "Invitation sent!"
         emails.each do |email|
              Delayed::Job.enqueue InvitationJob.new(email,current_user.id,message)
         end
       end  
      
      
    end
  end 
    
end
