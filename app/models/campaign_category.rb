class CampaignCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :campaigns
  
end
