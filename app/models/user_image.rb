class UserImage < Asset
  has_attached_file :attachment,:whiny=>false, :styles => { :thumb => "100x100#",:medium => "500x500>" },
    #:path => ":rails_root/public/assets/images/userimages/:id/:style/:basename.:extension",
    #:url => "/assets/images/userimages/:id/:style/:basename.:extension"
    :path => ":rails_root/public/system/userimages/:id/:style/:basename.:extension",
    :url =>"/system/userimages/:id/:style/:basename.:extension"
    
  
  validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/jpg' ,'image/gif'] , :message => "is not a Valid Image" 
  validates_attachment_size :attachment, :less_than => 2.megabytes , :message=> "should be less than 2 MB"
  validates_attachment_presence :attachment
end