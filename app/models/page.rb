class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :page_title, use: :slugged
  scope :p_order, lambda {order("page_order ASC")}
  
  auto_html_for :page_content do
    html_escape
    image
    youtube(:width => 420,:height => 250)
    vimeo(:width => 415,:height => 250)
    metacafe(:width => 415,:height => 250)
    dailymotion(:width => 415,:height => 250)
    google_video(:width => 415,:height => 250)
    
    link :target => "_blank", :rel => "nofollow"
    simple_format
end
  
  validates :page_title, :presence => true
  validates :page_name,  :presence => true
  validates :page_content, :presence => true
  
  
end
