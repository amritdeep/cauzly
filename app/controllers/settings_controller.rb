class SettingsController < ApplicationController
  layout :layout_check 
  
  def index
    @user = current_user
  end
  
  
  def changepassword
    @user = current_user
  end

  def updatepassword
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to settings_url,:notice => "Your password has been changed successfully"
    else
      render "changepassword"
    end
  end  

 def layout_check
   if current_user.is_admin?
      "admin"
   else
      "userprofile"
   end
 end
end
