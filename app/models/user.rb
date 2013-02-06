class User < ActiveRecord::Base
  extend FriendlyId
  #USER_TYPES = %w(charity sponsor donor)
  acts_as_followable
  acts_as_follower
  
  belongs_to :user_type
  
  has_one :address,:dependent => :destroy
  has_one :profile,:dependent => :destroy
  has_many :authentications, :dependent => :destroy
  has_many :user_posts,:dependent => :destroy
  has_one :user_logo, :as => :assetable, :class_name => "UserLogo", :dependent => :destroy
  has_many :user_images, :as => :assetable, :class_name => "UserImage", :dependent => :destroy
  has_one :social_link ,:dependent => :destroy
  
  has_many :user_videos, :as => :videoable, :class_name => "UserVideo", :dependent => :destroy
  has_one :card_token ,:dependent => :destroy
  has_many :made_donations ,:class_name=>"Donation",:foreign_key => "donor_id", :dependent => :destroy
  has_many :donations,:as => :donatable, :dependent => :destroy
  accepts_nested_attributes_for :user_videos, :allow_destroy => :true
  accepts_nested_attributes_for :profile
  
  #before_create :create_profile_name
  has_many :campaigns, :dependent => :destroy
  has_one :payment_receiving_info
  
  friendly_id :profile_name
 
  validates :profile_name,:uniqueness => { :case_sensitive => false },:length => 2..36,:format=>{ :with => /^[a-zA-Z0-9_]*$/,:message => "can't contain any spaces and punctuations."},:allow_nil =>true
  
  
  

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable#,:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:role,:user_type_id,:profile_name,:user_videos_attributes,:profile_attributes
  
  #validates :email, :uniqueness => true
  #validates :password, :presence=>true,:confirmation => true ,:if password_required?
   
  validates :user_type_id, :presence => true
 # validates :
  
  
  
  #validation for reserved usernames
  validate :validate_claimed_reserved_username
  
  
  
  def apply_omniauth(omniauth)
    if omniauth['provider'] == "twitter"
      ##self.email = omniauth['user_info']['email'] if email.blank?
      #self.username = omniauth['user_info']['nickname'] if username.blank?
    else
      #self.email = omniauth['user_info']['email'] if email.blank?
      #self.username = omniauth['user_info']['nickname'] if username.blank?
    end
    authentications.build(
      :provider => omniauth['provider'],
      :uid => omniauth['uid'],
      :secret => omniauth['credentials']['secret'],
      :token => omniauth['credentials']['token']  
    )
  end
  
  def apply_firstgiving_data(api_data)
   org_name= api_data['organization_name'] || ""
    build_profile(
    
      :name => org_name.humanize,
      :description => org_name.humanize,
      :ein => api_data['government_id'],
      :website => api_data['url'],
      :phone => api_data['phone_number'],
      :qualified_501c => true,  
      :charity_id => api_data['organization_uuid']
    )
   # build_address(
   # :state_id => State.find_by_state_code(api_data['region']).id,
   # :zip_code => api_data['postal_code'],
   # :city_name => api_data['city'],
   # :address1 => api_data['address_line_1'],
   # :address2 => api_data['address_line_2']
    
   # )
  end
   #def build_profile_record()
  
  def is_admin?
      return self.user_type.name.upcase == "ADMINISTRATOR"
  end
  
  def is_sponsor?
      return self.user_type.name.upcase == "SPONSOR" ? true : false
  end
    
  def is_non_profit?
      return self.user_type.name.upcase == "NONPROFITS" ? true : false
    
  end
  
  def create_profile_name
    #self.profile_name = Time.now.to_i * rand(99)
  end
  
  def url_param
    if !self.profile_name.nil? && !self.profile_name.empty?  
      self.profile_name
      
    else
      self.id  
    end
  end
  
 def self.all_user
    self.where("UPPER(user_type) != ?","ADMIN") 
 end
  
  def has_profile?
   self.profile.nil? ? false : true 
  end
  
  def is_501c_applicabale?
    if self.user_type.name.upcase == "NONPROFITS" 
      true
    else
      false
    end  
  end
  
  
  def has_payment_receiving_info?
    unless self.payment_receiving_info.blank?
       if self.payment_receiving_info.email?
          true
       else
         false
       end
    else
      false
    end
       
  end
  
  
  def display_name
    if !self.profile.nil?
      if self.profile.name?
        self.profile.name
      else
        self.email
      end  
    else
      self.email
    end
  end
  def profile_percent
    percent = 100
    if self.profile.blank?
      percent = percent-30
    end
    if !self.profile_name?
      percent = percent - 10
    end
    if self.user_logo.blank?
     percent = percent - 10 
    end
    if self.address.blank?
     percent = percent - 30 
    end
    if self.social_link.blank?
     percent = percent - 10 
    end
    
    percent
  end
  
  
  
  
  
  def self.search_user(search_params)
      
      if !search_params[:key].blank?
          if !search_params[:state_id].blank? && !search_params[:user_type_id].blank?
             users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id LEFT JOIN profiles on profiles.user_id = users.id').where(" (profiles.name like (?) or users.email like (?)) and  addresses.state_id = (?)  and users.user_type_id = ?  ","%"+search_params[:key]+"%","%"+search_params[:key]+"%",search_params[:state_id],search_params[:user_type_id])
          elsif !search_params[:state_id].blank?
             users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id LEFT JOIN profiles on profiles.user_id = users.id').where(" (profiles.name like (?) or users.email like (?)) and  addresses.state_id = (?)","%"+search_params[:key]+"%","%"+search_params[:key]+"%",search_params[:state_id])
          elsif !search_params[:user_type_id].blank?
             users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id LEFT JOIN profiles on profiles.user_id = users.id').where(" (profiles.name like (?) or users.email like (?))   and users.user_type_id = ?  ","%"+search_params[:key]+"%","%"+search_params[:key]+"%",search_params[:user_type_id])
          else
             users =  User.joins('LEFT JOIN profiles on profiles.user_id = users.id').where(" (profiles.name like (?) or users.email like (?) or users.profile_name like (?))","%"+search_params[:key]+"%","%"+search_params[:key]+"%","%"+search_params[:key]+"%")
          end  
      else  
          if !search_params[:state_id].blank? && !search_params[:user_type_id].blank?
             users =  User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where("addresses.state_id = (?)  and users.user_type_id = ?  ",search_params[:state_id],search_params[:user_type_id])
          elsif !search_params[:state_id].blank?
             User.joins('LEFT  JOIN addresses ON addresses.user_id = users.id').where("addresses.state_id = (?)",search_params[:state_id])
          elsif !search_params[:user_type_id].blank?
             users =  User.where(" users.user_type_id = ?  ",search_params[:user_type_id])
          else
             users =  User.joins("LEFT JOIN profiles on profiles.user_id = users.id").where("profiles.name is not null")
          end
      end
        
  end
  
  
  def validate_claimed_reserved_username
    
    reserverd_user_name=ReservedUsername.find_by_username(profile_name)
    if !reserverd_user_name.blank?
          if reserverd_user_name.user_id?
            
               errors.add(:profile_name,"is not available. Please try other.")
          else
              errors.add(:profile_name,"has been reserved by the admin. ")
          end
           
    end
  end  
  def profile_name_clamable?
    check = false
        reserverd_user_name=ReservedUsername.find_by_username(profile_name)
    if !reserverd_user_name.blank?
          if !reserverd_user_name.user_id?
             errors.add(:profile_name," has been reserved by the admin")
            check= true
          end
           
    end
    check
  end  
  
  def total_profile_raised
     total = Donation.sum(:amount,:conditions => ["donatable_id = ? and donatable_type = ?  ",self.id,"User"])
   
  end
  
  def total_raised
   self.total_profile_raised + self.total_campaign_raised
  end
  
  def total_campaign_raised
     campaign_ids = self.campaigns.map{|cam| cam.id}
     total = Donation.sum(:amount,:conditions => ["donatable_id in (?) and donatable_type = ?  ",campaign_ids,"Campaign"])
  end
  
  
  
  
end
