class UserType < ActiveRecord::Base
  extend FriendlyId
 
  scope :user_types, lambda { where("UPPER(name) != ?" ,"ADMINISTRATOR") } 
  
  scope :user_types_except_non_profit, lambda { where("UPPER(name) != ? and UPPER(name)!= ?" ,"ADMINISTRATOR", "NONPROFITS")}
  
  friendly_id :name , use: :slugged

  
  has_many :users
  validates :name,:presence => true
  
  def is_cause?
    if self.user_type.name.upcase == "INDIVIDUAL" || self.user_type.name.upcase == "COMPANY"
      false
    else
      true
    end  
  end
  
  def self.individual
     begin
      self.where("UPPER(name) like (?)","%INDIVIDUAL%").first
     rescue
     end
  end
  
  def self.company
     begin
      self.where("UPPER(name) like (?)","%COMPANY%").first
     rescue
     end
  end
  
  
  def self.all_causes
     self.where("UPPER(name) != ? and UPPER(name) !=  ? and UPPER(name) != ? ","INDIVIDUAL","COMPANY","ADMINISTRATOR")   
  end
  
  
end
