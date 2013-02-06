class Video < ActiveRecord::Base
#  include AutoHtmlFor
  
 
 attr_accessible :video_url,:videoable_id,:videoable_type,:video_title,:video_url_html
 belongs_to :videoable, :polymorphic => true
 validates :video_url ,:presence => true

auto_html_for :video_url do
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

end
