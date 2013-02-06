class NewsLetter < ActiveRecord::Base
  belongs_to :user_type
 before_save :add_user_type
  
  validates :subject,:presence => true
  validates :body,:presence => true
   
  
  def sent_unsent
    if self.sent_status == 0
      "Not sent"
    else
      "Sent"
    end
  end
  
  def recipients
    if self.user_type_id == 0
      "All users"
    else
      self.user_type.name.humanize
    end
  end
   
  def add_user_type
    if self.user_type_id.blank?
      self.user_type_id=0
    end
  end
  
  
  
  
end
