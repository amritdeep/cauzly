class UserCampaignsController < ApplicationController
  layout "userprofile"
  before_filter :require_login
  before_filter :check_non_profit
  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = current_user.campaigns.where("is_deleted is false").order("created_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    @campaign = current_user.campaigns.find(params[:id])
    @campaign_image = @campaign.campaign_images.build
    @campaign_video = @campaign.campaign_videos.build

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/new
  # GET /campaigns/new.json
  def new
    @campaign = current_user.campaigns.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campaign }
    end
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = current_user.campaigns.find(params[:id])
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = current_user.campaigns.new(params[:campaign])

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to user_campaign_url(@campaign), notice: 'campaign was successfully created.' }
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
    @campaign = current_user.campaigns.find(params[:id])

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to user_campaign_url(@campaign), notice: 'campaign was successfully updated.' }
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
    @campaign = current_user.campaigns.find(params[:id])
    @campaign.update_attribute(:is_deleted,true)

    respond_to do |format|
      format.html { redirect_to user_campaigns_url }
      format.json { head :no_content }
    end
  end

  def addimage
    @campaign = current_user.campaigns.find(params[:id])
    @campaign_image = @campaign.campaign_images.build(params[:campaign_image])
    @campaign_video = @campaign.campaign_videos.build

    if @campaign_image.save
      redirect_to user_campaign_url(@campaign)
    else
      render "show"
    end
  end

  def removeimage
    @campaign = current_user.campaigns.find(params[:id])
    @campaign_image = @campaign.campaign_images.find(params[:campaign_image_id])
    if @campaign_image.destroy

      redirect_to user_campaign_url(@campaign)
    else
      flash[:alert]="Error occured"
      redirect_to user_campaign_url(@campaign) ,:alert => "Some error occured"
    end
  end

  def addvideo
    @campaign = current_user.campaigns.find(params[:id])
    @campaign_video = @campaign.campaign_videos.build(params[:campaign_video])
    @campaign_image = @campaign.campaign_images.build
    if @campaign_video.save
      redirect_to user_campaign_url(@campaign)
    else
      flash[:alert]="Error occured"
      render "show"
    end
  end

  def removevideo
    @campaign = current_user.campaigns.find(params[:id])
    @campaign_video = @campaign.campaign_videos.find(params[:campaign_video_id])
    if @campaign_video.destroy

      redirect_to user_campaign_url(@campaign)
    else
      redirect_to user_campaign_url(@campaign) ,:alert => "Some error occured"
    end
  end

  def check_non_profit
    if !current_user.is_non_profit?
      redirect_to dashboard_url ,:notice => "You are restricted to this site"
    end
  end

  def donations_campaigns

    @campagin=Campaign.find(params[:id])

    if !@campagin.blank?

      @campagin_donations=@campagin.donations.order("created_at DESC").paginate(:per_page => 20,:page=>params[:page])

    end

  end

end
