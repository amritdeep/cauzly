class Profile < ActiveRecord::Base
  belongs_to :user
  
  # TO DO : phone no with or without hiphens validations
  validates :description,:presence=> true ,:on => :update
  validates :additional_information ,:length=>0..2000 

  #NOTE ::  please check with any validation chnages with User model's apply_firstgiving data method
end
