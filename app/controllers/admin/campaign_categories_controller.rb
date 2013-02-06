class CampaignCategoriesController < ApplicationController
  # GET /campaign_categories
  # GET /campaign_categories.json
  def index
    @campaign_categories = CampaignCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaign_categories }
    end
  end

  # GET /campaign_categories/1
  # GET /campaign_categories/1.json
  def show
    @campaign_category = CampaignCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campaign_category }
    end
  end

  # GET /campaign_categories/new
  # GET /campaign_categories/new.json
  def new
    @campaign_category = CampaignCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campaign_category }
    end
  end

  # GET /campaign_categories/1/edit
  def edit
    @campaign_category = CampaignCategory.find(params[:id])
  end

  # POST /campaign_categories
  # POST /campaign_categories.json
  def create
    @campaign_category = CampaignCategory.new(params[:campaign_category])

    respond_to do |format|
      if @campaign_category.save
        format.html { redirect_to @campaign_category, notice: 'Campaign category was successfully created.' }
        format.json { render json: @campaign_category, status: :created, location: @campaign_category }
      else
        format.html { render action: "new" }
        format.json { render json: @campaign_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /campaign_categories/1
  # PUT /campaign_categories/1.json
  def update
    @campaign_category = CampaignCategory.find(params[:id])

    respond_to do |format|
      if @campaign_category.update_attributes(params[:campaign_category])
        format.html { redirect_to @campaign_category, notice: 'Campaign category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @campaign_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaign_categories/1
  # DELETE /campaign_categories/1.json
  def destroy
    @campaign_category = CampaignCategory.find(params[:id])
    @campaign_category.destroy

    respond_to do |format|
      format.html { redirect_to campaign_categories_url }
      format.json { head :no_content }
    end
  end
end
