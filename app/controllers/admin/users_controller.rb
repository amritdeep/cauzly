class Admin::UsersController < ApplicationController
  layout "admin"
  before_filter :require_admin
  
  def index
      @users = User.paginate(:page =>params[:page], :order =>'user_type_id asc, id desc', :per_page =>NO_OF_USER_TO_DISPLAY)
  end
  
  def show
     
    @user         =   User.find(params[:id])
   
  
  end
  
  def edit
    @user         =   User.find(params[:id])
    @profile      = @user.profile || @user.build_profile
    
    #redirect_to admin_user_path(params[:id]) ,:alert=>"On implementation phase. Please visit later"
  end
  
  def update
    @user         =   User.find(params[:id])
     if @user.update_attributes(params[:user])
       redirect_to admin_users_path ,:notice=>"User updated successfully" 
     else
       msg = "<h3>Error occured.</h3>"
       if @user.errors.any?
       @user.errors.full_messages.each do |err|
       msg <<  err.to_s + "<br />"
       end
       end
      redirect_to edit_admin_user_url ,:alert =>  msg
     end
  end
  
  
 def filter_by_state_and_type
   #raise params.inspect
   if !params[:filter_by_state_and_type_admin_users].blank?
      if !params[:filter_by_state_and_type_admin_users][:state].blank? && !params[:filter_by_state_and_type_admin_users][:user_type].blank? 
       @state = State.find(params[:filter_by_state_and_type_admin_users][:state])
       @user_type = UserType.find(params[:filter_by_state_and_type_admin_users][:user_type])
       redirect_to user_filter_admin_users_path(@state,@user_type)  
       elsif  !params[:filter_by_state_and_type_admin_users][:state].blank?
           @state = State.find(params[:filter_by_state_and_type_admin_users][:state])
          #  raise params.inspect
            redirect_to user_filter_admin_users_path(:state_id => @state)
       elsif !params[:filter_by_state_and_type_admin_users][:user_type].blank?  
       @user_type = UserType.find(params[:filter_by_state_and_type_admin_users][:user_type])
       redirect_to user_filter_by_type_admin_users_path(@user_type)
       else 
         redirect_to admin_users_path and return 
      end   
   else
    
     redirect_to admin_users_path and return   
   end
 end
 
 def user_filter
   
   if !params[:state_id].blank? && !params[:user_type_id].blank?
       @state = State.find(params[:state_id])
       @user_type = UserType.find(params[:user_type_id])
     
    @users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = (?)  and user_type_id = ?  ",@state.id,@user_type.id).paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
     
   elsif !params[:state_id].blank?
       @state = State.find(params[:state_id]) 
   @users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = (?)",@state.id).paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
    
   elsif !params[:user_type_id].blank?
     @user_type = UserType.find(params[:user_type_id])
     @users =  User.where(" user_type_id = (?)",@user_type.id).paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
  
   else
     redirect_to admin_users_path and return
   end
   render "index"
 end
 
 def user_filter_by_type
 if !params[:user_type_id].blank?
     @user_type = UserType.find(params[:user_type_id])
     @users =  User.where(" user_type_id = (?)",@user_type.id).paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
  
   else
     redirect_to admin_users_path and return
   end
   render "index"
 end
 
 
 
 def search
   if !params[:user_filter].blank?
     @state = State.find(params[:user_filter][:state_id]) unless params[:user_filter][:state_id].blank?
     @user_type = UserType.find(params[:user_filter][:user_type_id]) unless params[:user_filter][:user_type_id].blank?
    @users = User.search_user(params[:user_filter]).paginate(:per_page => PER_PAGE_USERS,:page => params[:page] )
   if !params[:user_filter][:key].blank?
   @search_key = params[:user_filter][:key]
   else
  @search_key = ""
   end
   render "index"
   else
     redirect_to admin_users_url 
   end  
end 
 
 
 def campaigns
 @user = User.find(params[:user_id])
 @campaigns = Campaign.where("user_id =? ",@user.id).order(" created_at desc,end_date asc").paginate(:per_page => PER_PAGE_USERS,:page => params[:page])  
 end
 
 def destroy
  @user = User.find(params[:id]) 
  if @user && @user.is_admin?
  redirect_to admin_users_path ,:alert =>"This user cannot be deleted"
  else
    @user.destroy
    redirect_to admin_users_path ,:notice =>"User has been completely removed"
  end 
 end
 
 def donations
   
   @donation=Donation.where("donatable_type = 'User'").order("created_at desc").paginate(:per_page => 10,:page=>params[:page])

   
   
 end
 
 def api_nonprofitdonations
   
   @donation=Donation.where("donatable_type = 'ApiNonprofit'").order("created_at desc").paginate(:per_page => 10,:page=>params[:page])

   
   
 end
 
 
 
   
end
