class MembersController < ApplicationController
  
 
 def show 
    @user_type = UserType.find(params[:id])
    @states = State.all
    @user_types = UserType.user_types
    if !params[:q].blank?
        @users =  User.joins('LEFT  JOIN profiles ON profiles.user_id = users.id').where(" profiles.name like (?)  and user_type_id = ?  ","%"+params[:q]+"%",@user_type.id).order("users.created_at desc").paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
    else
     @users =  User.joins('LEFT  JOIN profiles ON profiles.user_id = users.id').where(" profiles.name is not null  and user_type_id = ?  ",@user_type.id).order("users.created_at desc").paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
     #  @users = @user_type.users.where("confirmation_token is null").paginate(:per_page => PER_PAGE_USERS, :page=>params[:page])
   
    end
 end 
 
 def members_index
    @states = State.all
    @user_types = UserType.user_types
 
    
    @param = params[:letter]
    @user_type = UserType.find(params[:id])
    
    @search_term  = "Alphabet   : #{params[:letter]}"
    @users =  User.joins('LEFT  JOIN profiles ON profiles.user_id = users.id').where(" profiles.name like (?)  and user_type_id = ?  ",params[:letter]+"%",@user_type.id).paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
   render "show"
 end
 
 
 def members_state
 
    @states = State.all
    @user_types = UserType.user_types
 
    @user_type = UserType.find(params[:id])
    @state = State.find(params[:state_id])
    
    @search_term  = "State : #{@state.name}"
    
    if !params[:q].blank?
       @users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id left join profiles on profiles.user_id = users.id').where(" addresses.state_id = (?)  and user_type_id = ?  and profiles.name like (?)",@state.id,@user_type.id,"%"+params[:q]+"%").paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
    else
     @users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = (?)  and user_type_id = ?  ",@state.id,@user_type.id).paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
    end
    #@users= User.paginate(:per_page => PER_PAGE_USERS,:page=>params[:page])
    
    #@search_term  = "State #{@state.name]}"
    #@users =  User.joins('LEFT  JOIN profiles ON profiles.user_id = users.id').where(" profiles.name like (?)  and user_type_id = ?  ",params[:letter]+"%",@user_type.id).paginate(:per_page => 5,:page => params[:page])
   render "show"
 end
 
 
 def members_state_index
      @states = State.all
    @user_types = UserType.user_types
 
    @user_type = UserType.find(params[:id])
    @state = State.find(params[:state_id])
    
    @skey = ""
    
    
    @search_term  = "State : #{@state.name}"
    
    if !params[:letter].blank?
      @skey = " <li><span class='divider'> / </span>Alphabet   : #{params[:letter]}</li>"
      lcond= "profiles.name like (?)"
    end
    
    
    
  #  @search_term  = "Alphabet   : #{params[:letter]}"
    @users =  User.joins(:profile).where(" profiles.name like (?)  and user_type_id = ?  ",params[:letter]+"%",@user_type.id).joins(:address).where("addresses.state_id = ? ",@state.id).paginate(:per_page => PER_PAGE_USERS,:page => params[:page])
    
    @search_term = @search_term + @skey
    #@users= User.paginate(:per_page => 2,:page=>params[:page])
    
    render "show"
    
 end
 
 
 def filter_by_state_and_type
   if !params[:filter_by_state_and_type_members].blank?
      if !params[:filter_by_state_and_type_members][:state].blank? 
       @state = State.find(params[:filter_by_state_and_type_members][:state])
       @user_type = UserType.find(params[:filter_by_state_and_type_members][:user_type])
      if !params[:filter_by_state_and_type_members][:q].blank? 
        redirect_to members_state_member_url(@user_type,@state,:q=>params[:filter_by_state_and_type_members][:q])  
      else
        redirect_to members_state_member_url(@user_type,@state)
      end
      else  
         
         @user_type = UserType.find(params[:filter_by_state_and_type_members][:user_type])
         
          if !params[:filter_by_state_and_type_members][:q].blank? 
        redirect_to member_url(@user_type,:q=>params[:filter_by_state_and_type_members][:q])  
      else
       redirect_to member_url(@user_type)  
      end
         
         
      end   
   else
      redirect_to member_url(@user_type,:q=>params[:filter_by_state_and_type_members][:q])  
   end
 end
   
end
