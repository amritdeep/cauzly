class Campaign < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  
  
  belongs_to :user
  belongs_to :campaign_category
  has_many :donations,:as => :donatable
  validates :campaign_category_id ,:presence => true
  
  #validates :start_date, :date_cannot_be_past => true
  
 validate :validate_end_date_before_start_date

  def validate_end_date_before_start_date
    if end_date && start_date
      errors.add(:end_date, "must be greater than Start Date") if end_date < start_date
      errors.add(:start_date, "cannot be past date") if start_date < Date.today
      errors.add(:end_date,"  can't be more than 60 days from start date") if end_date - 60.days > start_date 
    end
  end


  
   
    
    
   
    
  
  has_many :campaign_images, :as => :assetable,:class_name => "CampaignImage",:dependent => :destroy
  has_many :campaign_videos, :as => :videoable,:class_name => "CampaignVideo",:dependent => :destroy
  
  scope :top_six, limit(8).where("end_date>= ? and is_featured = ? and  is_deleted is false",Time.now,true).order("end_date ASC")
  
  
  
  
  
  def default_image
    unless self.campaign_images.blank?
      self.campaign_images.first
    else
    false
    end 
  end 
  
  def campaign_title_with_owner
    
    
   #user = User.find(self.user_id)
   # if !user.profile.blank? && user.profile.name?
   # "#{self.title}".camelize
   # else
    "#{self.title}".camelize
   # end 
     
  end
  
  def total_raised
    total_campaign=Donation.sum(:amount,:conditions => ["donatable_id = ? and donatable_type = ? ",self.id, "Campaign" ])
  end
  
  
  def is_active
    if self.end_date >= Time.now.to_date && !self.is_deleted
        true
     else
       false
    end
  end
  
end
