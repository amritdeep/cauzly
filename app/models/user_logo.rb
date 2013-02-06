class UserLogo < Asset
  has_attached_file :attachment, :styles => { :logo => "120x90>",:thumb => "150x100>",:small=>"60x60#" }, :whiny =>false,
    :path => ":rails_root/public/system/avatar/:id/:style/:basename.:extension",
    :url =>"/system/avatar/:id/:style/:basename.:extension"
    
   
  
  validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif'], :message =>"is not a Valid Image" 
  validates_attachment_size :attachment, :less_than => 2.megabytes, :message=> "should be less than 2MB"
  validates_attachment_presence :attachment

end