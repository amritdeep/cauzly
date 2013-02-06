class Admin::CampaignsController < ApplicationController
  layout "admin"
  before_filter :require_admin
  # GET /campaigns
  # GET /campaigns.json
  def index
    @htitle="Campaigns"
    @campaigns = Campaign.where("end_date >= (?) and  is_deleted is false",Time.now.to_date).order("end_date asc").paginate(:page =>params[:page], :order =>'start_date desc', :per_page =>NO_OF_USER_TO_DISPLAY)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    @campaign = Campaign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/new
  # GET /campaigns/new.json
  def new
    @campaign = Campaign.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = Campaign.find(params[:id])
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(params[:campaign])

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to admin_campaign_path(@campaign), notice: 'Campaign was successfully created.' }
        format.json { render json: @campaign, status: :created, location: @campaign }
      else
        format.html { render action: "new" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /campaigns/1
  # PUT /campaigns/1.json
  def update
    @campaign = Campaign.find(params[:id])

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to admin_campaign_path(@campaign), notice: 'Campaign was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign = Campaign.find(params[:id])
     @campaign.update_attribute(:is_deleted,true)

    respond_to do |format|
      format.html { redirect_to admin_campaigns_url }
      format.json { head :no_content }
    end
  end
  
  def featured_campaigns
     @htitle="Featured Campaigns"
    @campaigns= Campaign.where("is_featured = ? and start_date < ? and end_date > ?",true,Time.now,Time.now).paginate(:page =>params[:page], :order =>'start_date desc', :per_page =>NO_OF_USER_TO_DISPLAY) 
    render "index"
  end
  
  def add_to_featured
    @campaign= Campaign.find(params[:id])
    if @campaign.update_attribute(:is_featured,true)    
      flash[:notice] = "Added To Featured Campaign."
    else
      flash[:notice]= "!!OOPS, Error Ocurred."
    end
    redirect_to admin_campaigns_url
  end
  
  def removed_from_featured
    @campaign= Campaign.find(params[:id])
    if @campaign.update_attribute(:is_featured,false)
      flash[:notice] = "Successfully Removed From Featured Campaign."
    else
      flash[:notice]="!!OOPS, Error Ocurred."
    end
    redirect_to admin_campaigns_url
  end
  
  
   def campaign_donations
   
   @campaign_donation=Donation.where("donatable_type = 'Campaign'").order("created_at DESC").paginate(:per_page => 10,:page=>params[:page])
 end
  
  
end
