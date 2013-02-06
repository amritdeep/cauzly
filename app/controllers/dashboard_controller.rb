class DashboardController < ApplicationController
  layout "userprofile"
  before_filter :require_login
  #before_filter :load_user
  
  #before_filter :update_profile , :only =>[:nonprofit_profile,:sponsor_profile,:donor_profile]
 
  def index
     if current_user.profile.blank?
      redirect_to update_profile_url ,:alert => "Please  fill in required fields." 
    end
    #all values loaded from load_user filter
    @user   =   current_user
    @associated_providers = current_user.authentications.map{|authentication| authentication.provider}
    @not_yet_associated_providers =  SUPPORTED_PROVIDER - @associated_providers
  
  # this is for feed
  @following_ids = @user.all_following.map{|user| user.id}
  
  @following_ids << current_user.id
  

  @feeds = ActivityFeed.where("user_id in (?)",@following_ids).order("created_at DESC").paginate(:per_page => 20,:page => params[:page])

  
  end
  
  def my_profile
    @user   =   current_user
    @associated_providers = current_user.authentications.map{|authentication| authentication.provider}
    @not_yet_associated_providers =  SUPPORTED_PROVIDER - @associated_providers
  end
  
  def update_address
      @address  = current_user.address || current_user.build_address
      if request.post?
          #@address = current_user.address
         if  @address.update_attributes(params[:address])
           redirect_to :dashboard, :notice => "Profile Information Updated successfully"
         else
         end
      end    
  end
  
 
   def update_logo
        @user_logo  = current_user.user_logo || current_user.build_user_logo
        if request.post?
            #@user_logo = current_user.user_logo
           # raise params.inspect
           if !params[:user_logo].blank?
           if @user_logo.update_attributes(params[:user_logo])
             redirect_to :dashboard, :notice => "Profile Information updated successfully"
           else
             
           end
           else
             flash[:alert] = "Please choose file to upload"
           end
        end
   end

    def images
          @user_images = current_user.user_images
         @user_image  = current_user.user_images.build
    end
 
 
  def videos
         
        if request.post?
        # raise params.inspect
         if   current_user.update_attributes(params[:user])
             redirect_to :dashboard, :notice => "Profile Information updated successfully"
        end
        else
          if current_user.user_videos.blank?
            @current_user.user_videos.build
          else
            @user_videos = current_user.user_videos
          end
        end
  end
 
 
    def update_social_links
        @social_link  = current_user.social_link || current_user.build_social_link
        if request.post?
            #@social_link = current_user.social_link
          if  @social_link.update_attributes(params[:social_link])
             redirect_to :dashboard, :notice => "Profile Information updated successfully"
          else
          end
        end
    end
   
   def update_profile_name
        @user  = current_user
        if request.post?
          @user.profile_name = params[:user][:profile_name]
          if !@user.profile_name_clamable?
          if  @user.save
             redirect_to :dashboard, :notice => "Profile Information updated successfully"
          end
          else
          
          end
        end
    end
 
 
 def claim_request
  @user = current_user
  if !params[:claim].blank?
            @reserved_name=ReservedUsername.find_by_username(params[:claim])
                   if @reserved_name
                   if @reserved_name.update_attributes(:user_id =>current_user.id )
                       redirect_to update_profile_url, :notice => "Request successfully received for processing"
    
                        else
                              redirect_to update_profile_url, :notice => "Your Request is not Processed"
                            end
                    else
                       redirect_to dashboard_url, :alert => "Some error occured."
    
                    end
   else
     redirect_to  update_profile_url
   end
   
 end
 
 
 
 
 
     def update_profile
        @profile  = current_user.profile || current_user.build_profile
        if request.post?
             @profile = current_user.profile
             if @profile.update_attributes(params[:profile])
               redirect_to :dashboard, :notice => "Profile Information Updated successfully"
             end
             
        end
     end
 
 def payment_receiving_info
        @payment_receiving_info  = current_user.payment_receiving_info || current_user.build_payment_receiving_info
        if request.post?
             @payment_receiving_info = current_user.payment_receiving_info
             if @payment_receiving_info.update_attributes(params[:payment_receiving_info])
               redirect_to :dashboard, :notice => "Payment receiving information Updated successfully"
             end
             
        end
     end
 
   #filter method to redirect current user to corresponding update method
#   def update_profile
#      if current_user.is_nonprofit?
#        redirect_to :nonprofit_profile_update
#      elsif current_user.is_sponsor?
#        redirect_to :sponsor_profile_update
#      else
#        redirect_to :donor_profile_update
#      end
#   end
   
  
end
