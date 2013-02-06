class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  ################################################################
  #             TO DO : 
  #   Code CleanUP and code Formating. 
  
  #   Remove unnecessary controllers/models/methods view files
  
  #   There are several forward and revert cases so code left undeleted. 
   
  #   Move as much as logic to models rather than doing in controllers.
  
  #   Code is not fully in DRY principle in couple of places so need to make it DRY with making partials. 
  
  #   It is very important to delete, clean and comment the code before
  #   proceeding in to next phase because requirement will be much clear by then 
  
  
  #  Requirement for next phase seems conflicting to existing system so we need to look every thing from start.
  #  Lots of code will be useless in next phase.
  #
  #  TO DO : CLEAN , FORMAT, MOVE CODE IN PROPER PLACES, COMMENT , DRY    
  ################################################################

  
  
  
  
  def admin_check
     if current_user && current_user.is_admin?
      redirect_to  admin_dashboard_url
     end
  end

  def require_login
      admin_check
     if current_user
       @user = current_user
     end    
     if !current_user
      redirect_to new_user_session_url ,:alert => "Please login to access this page." and return
     end
  end
  
  def require_admin
     if current_user && current_user.is_admin?
      else
      redirect_to root_url ,:alert => "You need to logged in as Administrator to access this page." and return
     end
  end
  
  def after_sign_in_path_for(resource)
     if current_user && current_user.is_admin?
        return request.env['omniauth.origin'] || stored_location_for(resource) || admin_dashboard_url
     else
        return request.env['omniauth.origin'] || stored_location_for(resource) || dashboard_path
      end    
  end
  def redirect_logged_in
    if current_user
      redirect_to dashboard_url
    end
  end
  
  
  #def after_sign_up_path_for(resource)
  # redirect_to dashboard_url
  #end 
    
 
    
    
end
