class Admin::ReservedUsernamesController < ApplicationController
  layout "admin"
  before_filter :require_admin
  # GET /reserved_usernames
  # GET /reserved_usernames.json
  def index
    @reserved_usernames = ReservedUsername.order("user_id desc, username asc").paginate(:per_page => 20,:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reserved_usernames }
    end
  end

  # GET /reserved_usernames/1
  # GET /reserved_usernames/1.json
  def show
    @reserved_username = ReservedUsername.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reserved_username }
    end
  end

  # GET /reserved_usernames/new
  # GET /reserved_usernames/new.json
  def new
    @reserved_username = ReservedUsername.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reserved_username }
    end
  end

  # GET /reserved_usernames/1/edit
  def edit
    @reserved_username = ReservedUsername.find(params[:id])
  end

  # POST /reserved_usernames
  # POST /reserved_usernames.json
  def create
    @reserved_username = ReservedUsername.new(params[:reserved_username])

    respond_to do |format|
      if @reserved_username.save
        format.html { redirect_to admin_reserved_usernames_url , notice: 'Reserved username was successfully created.' }
        format.json { render json: @reserved_username, status: :created, location: @reserved_username }
      else
        format.html { render action: "new" }
        format.json { render json: @reserved_username.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reserved_usernames/1
  # PUT /reserved_usernames/1.json
  def update
    @reserved_username = ReservedUsername.find(params[:id])

    respond_to do |format|
      if @reserved_username.update_attributes(params[:reserved_username])
        format.html { redirect_to admin_reserved_usernames_url , notice: 'Reserved username was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reserved_username.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reserved_usernames/1
  # DELETE /reserved_usernames/1.json
  def destroy
    @reserved_username = ReservedUsername.find(params[:id])
    @reserved_username.destroy

    respond_to do |format|
      format.html { redirect_to admin_reserved_usernames_url }
      format.json { head :no_content }
    end
  end
  
  
  
  def approve_request
   
          reserved_usr_name = ReservedUsername.find(params[:reserved_username_id])
          
          get_user_id = reserved_usr_name.user_id
          user = User.find(get_user_id)
         #raise user.inspect
          
                if user.update_attribute(:profile_name,reserved_usr_name.username)
            
                #raise user.errors.inspect
                      if reserved_usr_name.destroy
                
                      redirect_to admin_reserved_usernames_url, :notice => "Request Approved Successfully"
            
                      end
                 else
                   redirect_to admin_reserved_usernames_url, :notice => "Request Processing Failed"
                end
          
          

 end




        def reject_request
          
          reserved_usr_name = ReservedUsername.find(params[:reserved_username_id])
          
          if reserved_usr_name.update_attributes(:user_id => nil)
            
              redirect_to admin_reserved_usernames_url, :notice => "Request rejected successfully"
              
          else
              redirect_to admin_reserved_usernames_url, :notice => "Request processing failed"
              
            end
          

        end


  
  
  
end



 