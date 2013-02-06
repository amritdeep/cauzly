class UserImagesController < ApplicationController
  layout "userprofile"
  before_filter :require_login
  # GET /profiles
  # GET /profiles.json
  
  # GET /profiles/new
  # GET /profiles/new.json
  def index
    @user = current_user   
    @user_images =  @user.user_images
  end
  
  def new
    @user_image = current_user.user_images.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_image }
    end
  end

 
  # POST /profiles
  # POST /profiles.json
  def create
    @user_image = current_user.user_images.new(params[:user_image])

    respond_to do |format|
      if @user_image.save
        format.html { redirect_to userimages_url, notice: 'Image uploaded successfully.' }
        format.json { render json: @user_image, status: :created, location: @user_image }
      else
        format.html { render action: "new" }
        format.json { render json: @user_image.errors, status: :unprocessable_entity }
      end
    end
  end

 
  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @user_image = current_user.user_images.find(params[:id])
   if @user_image
   
    @user_image.destroy

    respond_to do |format|
      format.html { redirect_to userimages_url }
      format.json { head :no_content }
    end
    else
      redirect_ro userimages_url,:alert => "Invalid action"
    end
  end
end
