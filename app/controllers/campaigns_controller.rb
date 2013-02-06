class CampaignsController < ApplicationController
   autocomplete :campaign, :title,:display_value => :campaign_title_with_owner,:full => true

   
  # GET /causes
  # GET /causes.json
  def index
    
    @campaigns = Campaign.where("end_date >= (?) and is_deleted is false",Time.now.to_date).order("end_date asc").paginate(:per_page => PER_PAGE_CAMPAIGNS,:page=>params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
      format.js
    end
  end

  def search
    
  end  

def campaigns_by_category
  
  @campaign_category =  CampaignCategory.find(params[:id])
  
    @campaigns = @campaign_category.campaigns.where("end_date > (?) and is_deleted is false",Time.now.to_date).order("end_date asc").paginate(:per_page => PER_PAGE_CAMPAIGNS,:page=>params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
      format.js
    end
  end
  
  def filter
    if !params[:filter_campaigns].blank?
      @sort_order = params[:filter_campaigns][:sort_order]
      if !params[:filter_campaigns][:category_id].blank? && !params[:filter_campaigns][:state_id].blank?
            @category = CampaignCategory.find(params[:filter_campaigns][:category_id])
            @state = State.find(params[:filter_campaigns][:state_id])
            redirect_to  filter_category_state_sort_campaigns_path(@sort_order,@category,@state)      
       elsif  !params[:filter_campaigns][:category_id].blank?
          @category = CampaignCategory.find(params[:filter_campaigns][:category_id])
          redirect_to  filter_category_sort_campaigns_path(@sort_order,@category)
       elsif  !params[:filter_campaigns][:state_id].blank?
           
            @state = State.find(params[:filter_campaigns][:state_id])
            redirect_to  filter_state_sort_campaigns_path(@sort_order,@state)
       else
         redirect_to  filter_sort_campaigns_path(@sort_order)
      end
    else
      redirect_to campaigns_url
    end
  end 
  
  
  def category_state_sort
    @sort_order = params[:sort_order]
    if @sort_order == "expiring"
      sort_by = "end_date asc" 
    else 
      sort_by = "end_date desc"
    end
    @category = CampaignCategory.find(params[:category_id])
    @state = State.find(params[:state_id])
    @user_ids= User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = (?)",@state.id).map{|u| u.id}      
    @campaigns = Campaign.where("end_date >= (?) and user_id in (?) and campaign_category_id = ? and is_deleted is false",Time.now,@user_ids,@category.id).order("#{sort_by}").paginate(:per_page => PER_PAGE_CAMPAIGNS,:page=>params[:page])
    render "index"
  end
  def category_sort
    @sort_order = params[:sort_order]
    if @sort_order == "expiring"
      sort_by = "end_date asc" 
    else 
      sort_by = "end_date desc"
    end
    @category = CampaignCategory.find(params[:category_id])
          
    @campaigns = Campaign.where("end_date >= (?) and campaign_category_id =? and is_deleted is false",Time.now,@category.id).order("#{sort_by}").paginate(:per_page => PER_PAGE_CAMPAIGNS,:page=>params[:page])
    render "index"
  end
  
  
  def state_sort
    @sort_order = params[:sort_order]
    if @sort_order == "expiring"
      sort_by = "end_date asc" 
    else 
      sort_by = "end_date desc"
    end
    @state = State.find(params[:state_id])
    @user_ids= User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where(" addresses.state_id = (?)",@state.id).map{|u| u.id}      
    @campaigns = Campaign.where("end_date >= (?) and user_id in (?) and is_deleted is false",Time.now,@user_ids).order("#{sort_by}").paginate(:per_page => PER_PAGE_CAMPAIGNS,:page=>params[:page])
    
    render "index"
  end
  
  def sort_order
    @sort_order = params[:sort_order]
    if @sort_order == "expiring"
      sort_by = "end_date asc" 
    else 
      sort_by = "created_at desc"
    end   
    @campaigns = Campaign.where("end_date >= (?) and is_deleted is false",Time.now).order("#{sort_by}").paginate(:per_page => PER_PAGE_CAMPAIGNS,:page=>params[:page])
    render "index"
  end
  # GET /causes/1
  # GET /causes/1.json
  def show
   
   @campaign = Campaign.find(params[:id])
   @user = @campaign.user 
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: campaign }
      format.js
    end
  end
  
  
  
  
end
