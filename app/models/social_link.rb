class SocialLink < ActiveRecord::Base
  belongs_to :user
  #before_validation :append
  
 validates :facebook,:twitter,:linkedin,:pinterest,:foursquare,:blog,:googleplus,:youtube, :allow_blank => true,:format =>{:with => URI::regexp(%w(http https))}  
  
  
  
  
  
 
  
  def append
  
  exp = /^https?:\/\//
  
    if !self.facebook.blank?   
         self.facebook = "http://www.facebook.com/"+ self.facebook unless exp.match(self.facebook)    
    end
    
    if !self.twitter.blank?
        self.twitter = "http://www.twitter.com/"+ self.twitter unless exp.match(self.twitter) 
    end
    
    
    if !self.linkedin.blank?
        self.linkedin ="http://www.linkedin.com/in/" + self.linkedin unless exp.match(self.linkedin)
    end
    
     if !self.pinterest.blank?
        self.pinterest ="https://www.pinterest.com/" + self.pinterest unless exp.match(self.pinterest)
    end
    
     if !self.foursquare.blank?
        self.foursquare ="http://www.foursquare.com/" + self.foursquare unless exp.match(self.foursquare)
    end
    
    
     if !self.googleplus.blank?
        self.googleplus ="http://plus.google.com/" + self.googleplus unless exp.match(self.googleplus)
    end
    
     if !self.youtube.blank?
        self.youtube ="http://www.youtube.com/" + self.youtube unless exp.match(self.youtube)
    end
    
    
    
  end

  
  
end

