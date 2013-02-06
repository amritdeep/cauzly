class Admin::FeaturedUsersController < ApplicationController
  layout "admin"
  before_filter :require_admin
  # GET /states
  # GET /states.json
  def index
    @featured_users = FeaturedUser.paginate(:per_page => 20,:page=>params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @states }
    end
  end

 
  # GET /states/1/edit
  def edit
    @featured_user = FeaturedUser.find(params[:id])
  end

  # POST /states
  # POST /states.json
  def create
   
    @featured_user = FeaturedUser.find_by_user_id(params[:user_id])
    if @featured_user.blank?
     
      @featured_user = FeaturedUser.new(params[:featured_user])
      @featured_user.user_id = params[:user_id]
       @msg = "Added to  featured list "
    else
      @msg = "Already in the  featured list "
    end 
    respond_to do |format|
      if @featured_user.save
        format.html { redirect_to admin_featured_users_url, notice: 'Added to featured listing.' }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  # PUT /states/1
  # PUT /states/1.json
  def update
    @featured_user = FeaturedUser.find(params[:id])

    respond_to do |format|
      if @featured_user.update_attributes(params[:featured_user])
        format.html { redirect_to admin_featured_users_url, notice: 'Featured item successfully updated.' }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    @featured_user = FeaturedUser.find(params[:id])
    @featured_user.destroy

    respond_to do |format|
      format.html { redirect_to admin_featured_users_url }
      format.js
    end
  end
end
