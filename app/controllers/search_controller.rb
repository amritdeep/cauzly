class SearchController < ApplicationController
   #autocomplete :brand, :name
  # GET /causes
  # GET /causes.json
  
  def causes
    @key =""
   if params[:cause_keyword]
    @key =  params[:cause_keyword]
     #@causes = Cause.where("title like ? and end_date < ?" , params[:cause_search][:keyword]+"%",Time.now).paginate(:per_page => 1,:page => params[:page])
     @causes = Campaign.where("title like ?" , "%"+@key+"%").paginate(:per_page => 5,:page => params[:page])
   else
     @causes = Campaign.where("end_date <> ?",Time.now).paginate(:per_page => 5,:page => params[:page])
   end
   
  end
 
 
  def members
    @states = State.all
    @user_types = UserType.user_types
    
    
    
    if params[:members_search]
      if !params[:members_search][:state].blank? && !params[:members_search][:user_type].blank?
        state = State.find(params[:members_search][:state])
        user_type = UserType.find(params[:members_search][:user_type]) 
        @search_term  = "State : #{state.name}   Type : #{user_type.name}"  
          @users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = ? and user_type_id = ? and user_type_id != ?  ",params[:members_search][:state],params[:members_search][:user_type],1).paginate(:per_page => 5,:page => params[:page])
      elsif params[:members_search][:state].blank?
        user_type = UserType.find(params[:members_search][:user_type]) 
        @search_term  = "Type : #{user_type.name}"  
        
          @users =  User.where(" user_type_id = ? and user_type_id != ?  ",params[:members_search][:user_type],1).paginate(:per_page => 5,:page => params[:page])
      elsif params[:members_search][:user_type].blank?
          state = State.find(params[:members_search][:state])
        @search_term  = "State : #{state.name}"  
        
          @users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = ?  and user_type_id != ?  ",params[:members_search][:state],1).paginate(:per_page => 5,:page => params[:page])
      else
            
      end
     
     else
    
      @users = User.where("user_type_id != 1 ").paginate(:per_page => 5,:page => params[:page])
    end
         
  end
 
 
 def members_index 
   @states = State.all
    @user_types = UserType.user_types
    @search_term  = "Alphabet   : #{params[:letter]}"
    @users =  User.joins('LEFT  JOIN profiles ON profiles.user_id = users.id').where(" profiles.name like (?)  and user_type_id != ?  ",params[:letter]+"%",1).paginate(:per_page => 5,:page => params[:page])
 end 
   
 
 
  
  def cause_results
    
    @causes = Cause.where("title like ?" , params[:key]+"%")
#raise @causes.inspect
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @causes }
    end
  end

  def search
    
  end  


  # GET /causes/1
  # GET /causes/1.json
  def show
    @user = User.find(params[:user_id])
    @cause = @user.causes.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cause }
    end
  end
  
  

  # GET /causes/new
  # GET /causes/new.json
  def new
    @cause = current_user.causes.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cause }
    end
  end

  # GET /causes/1/edit
  def edit
    @cause = current_user.causes.find(params[:id])
  end

  # POST /causes
  # POST /causes.json
  def create
    @cause = current_user.causes.new(params[:cause])

    respond_to do |format|
      if @cause.save
        format.html { redirect_to user_cause_url(@cause), notice: 'Cause was successfully created.' }
        format.json { render json: @cause, status: :created, location: @cause }
      else
        format.html { render action: "new" }
        format.json { render json: @cause.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /causes/1
  # PUT /causes/1.json
  def update
    @cause = current_user.causes.find(params[:id])

    respond_to do |format|
      if @cause.update_attributes(params[:cause])
        format.html { redirect_to user_cause_url(@cause), notice: 'Cause was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cause.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /causes/1
  # DELETE /causes/1.json
  def destroy
    @cause = current_user.causes.find(params[:id])
    @cause.destroy

    respond_to do |format|
      format.html { redirect_to user_causes_url }
      format.json { head :no_content }
    end
  end
  
   def addimage
     @cause = current_user.causes.find(params[:id])
     @cause_image = @cause.cause_images.build(params[:cause_image])
     if @cause_image.save
       redirect_to user_cause_url(@cause)
     end
  end
  
  def removeimage
    @cause = current_user.causes.find(params[:id])
     @cause_image = @cause.cause_images.find(params[:cause_image_id])
     if @cause_image.destroy
       
       redirect_to user_cause_url(@cause)
     else
       redirect_to user_cause_url(@cause) ,:alert => "Some error occured" 
     end
  end 

 def addvideo
     @cause = current_user.causes.find(params[:id])
     @cause_video = @cause.cause_videos.build(params[:cause_video])
     if @cause_video.save
       redirect_to user_cause_url(@cause)
     end
  end

  def removevideo
    @cause = current_user.causes.find(params[:id])
     @cause_video = @cause.cause_videos.find(params[:cause_video_id])
     if @cause_video.destroy
       
       redirect_to user_cause_url(@cause)
     else
       redirect_to user_cause_url(@cause) ,:alert => "Some error occured" 
     end
  end
  
end
