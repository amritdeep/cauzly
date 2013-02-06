class State < ActiveRecord::Base
  extend FriendlyId
  has_many :cities ,:dependent => :destroy
  has_many :addresses
  accepts_nested_attributes_for :cities, :allow_destroy => :true
  scope :alphabetically ,:order=> "name asc"
   
  friendly_id :name ,use: :slugged
end
