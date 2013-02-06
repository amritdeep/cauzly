class ProfileController < ApplicationController
  layout "publicprofile"
  around_filter :catch_not_found
  #after_filter :load_user
  def index
    @user         =   User.find(params[:id])

  end
  
   def share_donation
          
          @donation=Donation.find(params[:donation_id])
          @user= @donation.donor
          if @donation.donatable_type=="Campaign"
            @share_url= campaign_url(@donation.donatable)
            
                end
            
          
          
            
          
          
          if @donation.donatable_type=="User"
            @share_url = profile_url(@donation.donatable)
             
          end
          
           
          if @donation.donatable_type=="ApiNonprofit"
              @share_url = root_url
          end
         
  
  end  
  
   
  
  # wanted to do ajax loading of all these methods in profile page
  #now doing simple call 
  def activities
    
  end
  
  def campaigns
    @user = User.find(params[:id])
    @campaigns = @user.campaigns.where("end_date >= (?) and is_deleted is false",Time.now.to_date)
  end
  
  def videos
    @user = User.find(params[:id])
    @videos = @user.user_videos
    
  end
  
  def images
    @user = User.find(params[:id])
    @images = @user.user_images
    
  end
  
  def campaign_detail
    @user = User.find(params[:id])
    @campaign = @user.campaigns.find(params[:campaign_id])
    
  end
    
    
  def follower
          @user = User.find(params[:id])
          @followers = @user.user_followers.paginate(:per_page => 20,:page => params[:page])
          render "follow/follower"
  end
  def following
   
       
          @user = User.find(params[:id])
          @following = @user.following_users.paginate(:per_page => 20,:page => params[:page])
        
        render "follow/following"
  end
  
  def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url,  :alert => "Page does not exist." 
  end
  
  
  
  
  
end