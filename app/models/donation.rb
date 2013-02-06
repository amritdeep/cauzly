class Donation < ActiveRecord::Base
  belongs_to :donor,:class_name => "User",:foreign_key => "donor_id"
  belongs_to :donatable,:polymorphic => true

  attr_accessor  :first_name,:last_name,
    :phone,:address1,:address2,:city,:state,:zip_code,:country,
    :description,
    :donation_message,:honor_name,:email,#will be saved
    :card_number,:card_type,:expiry_year,:expiry_month,:verification_code, #will not be saved
    :charity_id,:ein,:donation_type,:saved_for_future_use,:name_on_card,:use_card_on_file
       
 
                      
 validates :first_name,:last_name,
    :address1,:city,:state,:zip_code,:country,
    :description,
    :email,#will be saved
    :name_on_card,:card_type,:card_number,:verification_code, :expiry_month,:expiry_year,:presence => true, :unless => :use_card?
    
 validates :amount,:presence=> true,:numericality => {:greater_than_or_equal_to => 5.00}
 
 validates :card_number,:verification_code,:numericality=>true,  :unless => :use_card?
 
 def amt
   ActionController::Base.helpers.number_with_precision(self.amount,:precision=>2)
 end

def future_use?
  unless saved_for_future_use.blank?
     if saved_for_future_use.to_i == 1
      
       true
     else
       false
     end
  else
    false
  end
end
 
def use_card?
  unless use_card_on_file.blank?
     if use_card_on_file.to_i == 0
      
       false
     else
       true
     end
  else
    false
  end
end

 
 def prepare_array_for_api
   
   array_to_post = [
   'ccNumber'        => self.card_number,
   'ccType'           =>self.card_type,
   'ccExpDateMonth'      => self.expiry_month  ,
   'ccExpDateYear'       => self.expiry_year  ,
   'ccCardValidationNum' => self.verification_code,
     #,'billToTitle'=> self.verification_number
   'billToFirstName'     => self.first_name,
   'billToLastName'      => self.last_name,
   'billToAddressLine1'  => self.address1,
   'billToAddressLine2'  => self.address2,
   'billToCity'          => self.city,
   'billToState'         => self.state,
   'billToZip'           => self.zip_code,
   'billToCountry'      => self.country,
   'billToEmail'        => self.email,
  # 'billToPhone'        => self.phone,
   'remoteAddr'         => self.donor_ip,
   'charityId'          => self.charity_id,
   'orderId'            => self.tracking_no,
   'description'        => self.description,
   'amount'             => self.amt,
   'currencyCode'       => "USD"          
   ]
   array_to_post.to_param
   
 end
 
 
 def make_donation_call(data)
    cc_donation_url = "donation/creditcard"
    @url = FGIVING_DONATION_PRO_URL + cc_donation_url
    
    
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #http.ca_file = "equifax_ca.crt"
    #http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri,initheader = {
      'JG_APPLICATIONKEY' => FGIVING_APP_KEY,
      'JG_SECURITYTOKEN' => FGIVING_SECURITY_TOKEN
      })
    request.body = data #payload is defined earlier as a hash with key/value pair
    
   
    response = http.request(request)
    
    response.body
  
  end
  
  
  
  
  
  
  def card_on_file_prepare
   
   array_to_post = [
   'ccNumber'        => self.card_number,
   'ccType'           =>self.card_type,
   'ccExpDateMonth'      => self.expiry_month  ,
   'ccExpDateYear'       => self.expiry_year  ,
   'ccCardValidationNum' => self.verification_code,
     #,'billToTitle'=> self.verification_number
   'accountName'         => self.name_on_card,
   'billToFirstName'     => self.first_name,
   'billToLastName'      => self.last_name,
   'billToAddressLine1'  => self.address1,
   'billToAddressLine2'  => self.address2,
   'billToCity'          => self.city,
   'billToState'         => self.state,
   'billToZip'           => self.zip_code,
   'billToCountry'      => self.country,
   'billToEmail'        => self.email,
  
   'remoteAddr'         => self.donor_ip,
   'currencyCode'       => "USD"          
   ]
   array_to_post.to_param
   
 end
 
 
 def donation_param_card_on_file(cardonfile_id)
   array_to_post = [
   'cardOnFileId' => cardonfile_id,
   'charityId'          => self.charity_id,
   'orderId'            => self.tracking_no,
   'description'        => self.description,
   'amount'             => self.amt,
   'remoteAddr'         => self.donor_ip,
   'currencyCode'       => "USD"             
   ]
   array_to_post.to_param
   
 end

  def make_cardonfile_call(data)
    cc_card_on_file_url = "cardonfile"
    @url = FGIVING_DONATION_PRO_URL + cc_card_on_file_url
    
    
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #http.ca_file = "equifax_ca.crt"
    
    request = Net::HTTP::Post.new(uri.request_uri,initheader = {
      'JG_APPLICATIONKEY' => FGIVING_APP_KEY,
      'JG_SECURITYTOKEN' => FGIVING_SECURITY_TOKEN
      })
    request.body = data #payload is defined earlier as a hash with key/value pair
    
   
    response = http.request(request)
    
    response.body
  
  end
  
  
  def make_donation_call_via_card_file(data)
   cc_donation_url = "donation/creditcard"
    @url = FGIVING_DONATION_PRO_URL + cc_donation_url
    
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #http.ca_file = "equifax_ca.crt"
    
    request = Net::HTTP::Post.new(uri.request_uri,initheader = {
      'JG_APPLICATIONKEY' => FGIVING_APP_KEY,
      'JG_SECURITYTOKEN' => FGIVING_SECURITY_TOKEN
      })
    request.body = data #payload is defined earlier as a hash with key/value pair
    
   
    response = http.request(request)
    
    response.body
  end

  
  
  
 
 def response_result(res)
     hashed_response =  Hash.from_xml(res)
     hashed_response['firstGivingDonationApi']['firstGivingResponse']
  

  end
 
end
