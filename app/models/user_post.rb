class UserPost < ActiveRecord::Base
   
  belongs_to :user 
  validates :post ,:presence => true
  before_create :add_space_at_end
  
  auto_html_for :post do
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

  
  
  def add_space_at_end
    self.post = self.post + " " 
  end
end
