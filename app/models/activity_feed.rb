class ActivityFeed < ActiveRecord::Base
  belongs_to :activity_source ,:polymorphic => true
end
