class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :state
  #validates :state_id,  :presence => true
  validates :city_name ,:presence =>true
  validates :address1, :presence => true
  validates :zip_code, :presence => true#, :numericality => {:message=>"must be a number"}
  #NOTE : Please check user_model's apply_firstgiving method while chnaginf validation rules

 def full_address
    unless self.id.nil?
    [self.address1, self.address2, self.city_name, self.state.name,self.zip_code].delete_if{|ad_elem| ad_elem.blank?}.join(', ')
    else
    nil
    end
 end
 
 def city_state
    unless self.id.nil?
        if !self.state.blank?
          [self.city_name,self.state.name].delete_if{|ad_elem| ad_elem.blank?}.join(', ')
        elsif self.city?
          [self.city_name].delete_if{|ad_elem| ad_elem.blank?}.join(', ')
        else 
          nil
        end
    else
    nil
    end
 end
 
end
