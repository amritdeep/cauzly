class NonprofitSearchController < ApplicationController
  
  def index
  end
  
  def get_nonprofit_from_api
    @ein = params[:ein]
    
    unless @ein.blank?
      
    
    
    begin
      
    @profile = Profile.find_by_ein(@ein)
    if @profile.blank?  
    @result =  NonProfitSearchApi.search(@ein)
    
    
    
               if !@result.nil?
              
                 session[:valid_firstgiving_user] = @result
                 redirect_to new_user_registration_url ,:alert => "We need your email and password for registration" and return
     
               else
                 redirect_to new_user_registration_url ,:alert => "We didn't find your EIN number. Please enter your correct EIN number" and return
               end
     
     else
       redirect_to new_user_session_url ,:alert => "This EIN is already registered. Please Login. " and return
     end
     
    
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,Errno::ETIMEDOUT,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      redirect_to new_user_registration_url ,:alert => "Connection error occured. Please try again later." and return
    end

    
    
    else
      redirect_to new_user_registration_url and return 
    end
  end
  
  def api_nonprofit
      begin
      
   
 
    @result =  NonProfitSearchApi.search(params[:ein])
    
    
    
               if !@result.nil?
              
                #raise @result.inspect 
               else
                # redirect_to new_user_registration_url ,:alert => "We didn't find your EIN number. Please enter your correct EIN number" and return
               end
   
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      #redirect_to new_user_registration_url ,:alert => "Connection error occured. Please try again later." and return
    end

    
  end
  
  
end
