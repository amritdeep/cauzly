class City < ActiveRecord::Base
  belongs_to :state
  
  #validates :state_id ,:presence => true
  validates :name ,:presence => true  
end
