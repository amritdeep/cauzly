class CampaignImage < Asset
  belongs_to :campaign
  has_attached_file :attachment, :whiny=>false, :styles => { :thumb => "100x100#",:big_thumb=>"200x120#",:medium => "500x400#",:small=>"60x60#" },
    #:path => ":rails_root/public/assets/images/userimages/:id/:style/:basename.:extension",
    #:url => "/assets/images/userimages/:id/:style/:basename.:extension"
    :path => ":rails_root/public/system/campaignsimages/:id/:style/:basename.:extension",
    :url =>"/system/campaignsimages/:id/:style/:basename.:extension"
    
  validates_attachment_content_type :attachment, :content_type => ['image/jpeg', 'image/png', 'image/jpg','image/png'] ,:message=>" not a valid Image"
  validates_attachment_size :attachment, :less_than => 2.megabytes
  validates_attachment_presence :attachment
  
end