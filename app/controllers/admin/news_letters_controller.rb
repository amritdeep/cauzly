class Admin::NewsLettersController < ApplicationController
  layout "admin"
  before_filter :require_admin
  
  # GET /news_letters
  # GET /news_letters.json
  def index
    @news_letters = NewsLetter.order("sent_status asc,created_at desc ").paginate(:per_page => 2,:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news_letters }
    end
  end

  # GET /news_letters/1
  # GET /news_letters/1.json
  def show
    @news_letter = NewsLetter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @news_letter }
    end
  end

  # GET /news_letters/new
  # GET /news_letters/new.json
  def new
    @news_letter = NewsLetter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @news_letter }
    end
  end

  # GET /news_letters/1/edit
  def edit
    @news_letter = NewsLetter.find(params[:id])
  end

  # POST /news_letters
  # POST /news_letters.json
  def create
    @news_letter = NewsLetter.new(params[:news_letter])

    respond_to do |format|
      if @news_letter.save
        format.html { redirect_to admin_news_letter_url(@news_letter), notice: 'News letter was successfully created.' }
        format.json { render json: @news_letter, status: :created, location: @news_letter }
      else
        format.html { render action: "new" }
        format.json { render json: @news_letter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /news_letters/1
  # PUT /news_letters/1.json
  def update
    @news_letter = NewsLetter.find(params[:id])

    respond_to do |format|
      if @news_letter.update_attributes(params[:news_letter])
        format.html { redirect_to admin_news_letter_url(@news_letter), notice: 'News letter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @news_letter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_letters/1
  # DELETE /news_letters/1.json
  def destroy
    @news_letter = NewsLetter.find(params[:id])
    @news_letter.destroy

    respond_to do |format|
      format.html { redirect_to admin_news_letters_url,:notice => "News letter was successfully deleted." }
      format.json { head :no_content }
    end
  end
  
  def send_news_letter
    @news_letter = NewsLetter.find(params[:id])
    @news_letter.update_attributes(:sent_status => 1 )
    Delayed::Job.enqueue NewsLetterJob.new(@news_letter)
    
    redirect_to admin_news_letters_url,:notice => "Newsletter has been sent to recipient(s)"
  end
  
end
