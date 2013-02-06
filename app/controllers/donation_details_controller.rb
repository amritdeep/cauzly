class DonationDetailsController < ApplicationController
 layout "userprofile"
  before_filter :require_login 
 
  def details_donatable
    
    
  end
  
  def details_donations_made
    
    @donor_details=current_user.made_donations.order("created_at DESC").paginate(:per_page => 10,:page=>params[:page])
  end
  
  def details_donations_received
    @donations_received=current_user.donations.order("created_at DESC").paginate(:per_page => 10,:page=>params[:page])
  end
  
  
  
end
