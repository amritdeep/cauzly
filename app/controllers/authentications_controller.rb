class AuthenticationsController < ApplicationController
  layout "userprofile"
  def index
    if current_user
      @user = current_user
      @associated_providers = current_user.authentications.map{|authentication| authentication.provider}
      @not_yet_associated_providers =  SUPPORTED_PROVIDER - @associated_providers
    else
      redirect_to root_path
    end
    #redirect_to dashboard_path ,:notice => "Successfully associated with your account"
  end
  
  def create
    omniauth = request.env["omniauth.auth"]
    #raise omniauth.inspect
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
     # flash[:notice] = "You have Successfully signed in."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(
        :provider => omniauth['provider'], 
        :uid => omniauth['uid'],
        :secret => omniauth['credentials']['secret'],
        :token => omniauth['credentials']['token']
      )
      
      redirect_to dashboard_url ,:notice =>"#{omniauth['provider']} has been successfully associated with your account." 
    else
      
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url, :notice => "We need your email and password for cauzly.com to confirm your account "
      end
      #redirect_to new_user_registration_url ,:alert => "Sorry your account hasn't been associated with any account in cauzly.com. Please register using the form below."
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
  
  def failure
    redirect_to new_user_registration_url ,:alert => 'There was an error at the remote authentication service. You have not been signed in.'
  end
  
  
 
end
