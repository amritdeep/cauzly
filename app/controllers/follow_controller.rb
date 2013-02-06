class FollowController < ApplicationController
  before_filter :require_login
  layout "userprofile"
  
  def follow
    if request.xhr?
      begin
        
        @user_to_be_followed = User.find(params[:id])
        @user = @user_to_be_followed
        current_user.follow(@user_to_be_followed)
        respond_to do |format|
          format.js and return
        end
      rescue
         render :nothing => true and return   
      end
    else
      redirect_to user_home_url and return
    end
  end

  def unfollow
    if request.xhr?
      begin
        @user_to_be_unfollowed = User.find(params[:id])
        
        current_user.stop_following(@user_to_be_unfollowed)
        @user = @user_to_be_unfollowed
        respond_to do |format|
          @others = true if params[:others]
          format.js and return
        end
      rescue
         render :nothing => true and return   
      end
    else
      redirect_to user_home_url and return
    end
  end
  
  def follower
        if params[:id]
          user = User.find(params[:id])
          @followers = user.user_followers.paginate(:per_page => FOLLOWING_FOLLOWER_PER_PAGE,:page => params[:page])
        else  
          @followers = current_user.user_followers.paginate(:per_page => FOLLOWING_FOLLOWER_PER_PAGE,:page => params[:page])
        end
        respond_to do |format|
          format.html
          format.js
        end
        
    end
  
  def following
   
        if params[:id]
          user = User.find(params[:id])
          @following = user.following_users.paginate(:per_page => FOLLOWING_FOLLOWER_PER_PAGE,:page => params[:page])
        else  
          @following = current_user.following_users.paginate(:per_page => FOLLOWING_FOLLOWER_PER_PAGE,:page => params[:page])
        end
        respond_to do |format|
          format.html
          format.js  and return
        end
          
   
  end
  
  def block
    if request.xhr?
      begin
        @user_to_be_blocked = User.find(params[:id])
        
        current_user.block(@user_to_be_blocked)
        @user = current_user
        respond_to do |format|
         
          format.js and return
        end
      rescue
         render :nothing => true and return   
      end
    else
      redirect_to dashboard_path
    end
  end
  def unblock
    if request.xhr?
      begin
        @user_to_be_unblocked = User.find(params[:id])
        
        current_user.block(@user_to_be_blocked)
        respond_to do |format|
          @others = true if params[:others]
          format.js and return
        end
      rescue
         render :nothing => true and return   
      end
    else
      #redirect_to user_home_url and return
    end
  end
  
end