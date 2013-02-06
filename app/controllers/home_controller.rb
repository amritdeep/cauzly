class HomeController < ApplicationController
  def index
    @active_featured = FeaturedUser.where("start_date <= (?) and end_date >= (?)",Time.now,Time.now).map{|fu| fu.user_id}
   
    @users = User.where("id in (?)  ",@active_featured).order("rand()").limit(6)
    @recent_campaigns = Campaign.order("created_at desc").limit(10)
    @recent_members = User.where("user_type_id != ? and confirmation_token is null ",1).order("created_at desc").limit(10)
    @top_six=Campaign.top_six
  end
  
  def users
    redirect_to root_url
    #@users = User.paginate(:per_page => 5,:page => params[:page])
    
  end
  
  
  def sponsors
    @users = User.where("UPPER(user_type) = ? ","SPONSOR")
  end
  
  
  def donors
    @users = User.where("UPPER(user_type) = ? ","DONOR")
  end
  
  
   def find_non_profits
              
            end
  
  def search
    search_param = ""
    if params[:state]
      search_param_city = "state=#{params[:state]}"
        if params[:user_type]
          search_param_user_type = "user_type=#{params[:user_type]}"
          search_param = search_param_city + "&" + search_param_user_type
        
        else
          search_param_user_type = ""
          search_param = search_param_city
        end
    @users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = ? and user_type_id = ? and user_type_id != ?  ",params[:state],params[:user_type],1).paginate(:per_page => 5,:page => params[:page])
    
     else
    
      @users = User.where("user_type_id != 1 ").paginate(:per_page => 5,:page => params[:page])
    end
    
    
    
    @states = State.all
    @user_types = UserType.user_types
    
     
    
    
    if request.post?
      redirect_to member_search_url(search_param)
    end
    
    
  end
  
 
  
  def show_page
    @page=Page.find(params[:page_id])
    
  end
  
end
