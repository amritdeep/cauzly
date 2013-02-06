class RegistrationsController < Devise::RegistrationsController
  before_filter :redirect_logged_in
  def new
    @user = User.new
    
    #to prefill email and name of user if it is frm facebook
    if session[:omniauth] && session[:omniauth][:provider]=="facebook" && !session[:omniauth][:info].blank?
      email = ""
      name = ""
      email = session[:omniauth][:info][:email] if !session[:omniauth][:info][:email].blank?
      name = session[:omniauth][:info][:name] if !session[:omniauth][:info][:name].blank?
      @user.email = email
      @user.build_profile(:name => name)
    else
      @user.build_profile
    end
  end

  def fbinvite
    @user = User.new
    @user.build_profile

  end

  def create

    super
    unless @user.new_record?
      session[:valid_firstgiving_user] = nil
      session[:omniauth] = nil
    end

  end

  def not_me
    session[:valid_firstgiving_user] = nil
    redirect_to new_user_registration_url

  end

  private

  def build_resource(*args)
    super

    if session[:valid_firstgiving_user]
      @user.user_type_id = 3
      @user.apply_firstgiving_data(session[:valid_firstgiving_user])
    end

    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
    # @user.valid?
    end

  end
end
