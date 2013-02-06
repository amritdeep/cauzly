class DonationsController < ApplicationController
 force_ssl

  layout "publicprofile"
  before_filter :require_login
  def index

  end

  def new
    if current_user.address.blank?
      hash = { :donor_id => current_user.id,
        :email => current_user.email,
        :card_type => "VI",
        :amount    => 5.00
      }
    else
      @address = current_user.address
      hash =                     {    :donor_id => current_user.id,
        :email    => current_user.email,
        :address1 => @address.address1,
        :address2 => @address.address2,
        :city     => @address.city_name,
        :state    => @address.state.state_code,
        :zip_code => @address.zip_code,
        :card_type => "VI",
        :amount    => 5.00

      }
    end
    if params[:user_id]
      @user = User.find(params[:user_id])
      if !@user.blank?
        @donation = @user.donations.build(hash)
      #raise @donation.inspect
      else
        redirect_to root_url
      end
    elsif params[:campaign_id]
      @campaign = Campaign.find(params[:campaign_id])
      @user = @campaign.user
      @donation = @campaign.donations.build(hash)
    else
      redirect_to root_url
    end
    if request.post?

      params[:donation][:donor_id]         = current_user.id
      params[:donation][:email]            = current_user.email
      params[:donation][:description]      = "Donation via cauzly.com"
      params[:donation][:donation_message] = "Donation via cauzly.com"
      params[:donation][:country]          = "US"
      params[:donation][:charity_id]       = @user.profile.charity_id
      if params[:donation][:donation_type] == "Campaign"
        @donation              = @campaign.donations.build(params[:donation])
      else
        @donation              = @user.donations.build(params[:donation])
      end

      @donation.donor_ip     = request.remote_ip
      @donation.tracking_no  = rand(9999).to_s+Time.now.to_i.to_s+rand(9999).to_s # unique tracking_no
      
      
    #  raise @donation.use_card_on_file.inspect
 if @donation.valid?
  # raise params.inspect
        begin
       
       if @donation.use_card?
         #raise @donation.donor.card_token.card_token.inspect
                        
                                res       = @donation.make_donation_call_via_card_file(@donation.donation_param_card_on_file(@donation.donor.card_token.card_token ))
                                @response = @donation.response_result(res)
                                if @response['acknowledgement']=="Success"
                                    @donation.transaction_id = @response['transactionId']
                                    @donation.save
                                    flash[:notice] = "Donation request has been successfully submitted"
                                   # redirect_to dashboard_path
                                    redirect_to donation_detail_path(@donation) and return 
                                else
                                   @error =  @response['friendlyErrorMessage'] #+ @response['verboseErrorMessage'] + @response.to_s +   @donation.donation_param_card_on_file(@donation.donor.card_token.card_token).to_s
                                   flash[:alert] = @error
                                end
                       
         
       else
         
      
                  if @donation.future_use?
                      #raise @donation.card_on_file_prepare.inspect
                         res = @donation.make_cardonfile_call(@donation.card_on_file_prepare)
                         @cardon_file_response = @donation.response_result(res)
                        # raise @cardon_file_response.inspect
                         
                         if @cardon_file_response['acknowledgement']=="Success"
                                @card_token = @donation.donor.card_token || @donation.donor.build_card_token
                                @card_token.card_token = @cardon_file_response['cardOnFileId']
                                @card_token.save
                                
                                res       = @donation.make_donation_call_via_card_file(@donation.donation_param_card_on_file(@card_token.card_token))
                                @response = @donation.response_result(res)
                                if @response['acknowledgement']=="Success"
                                    @donation.transaction_id = @response['transactionId']
                                    @donation.save
                                    flash[:notice] = "Donation request has been successfully submitted"
                                   # redirect_to dashboard_path
                                    redirect_to donation_detail_path(@donation) and return 
                                else
                                   @error =  @response['friendlyErrorMessage'] #+@response['verboseErrorMessage'] + "Donation with token" + @donation.donation_param_card_on_file(@card_token.card_token).to_s
                                   flash[:alert] = @error
                                end
                         else
                             @error =  @cardon_file_response['friendlyErrorMessage']
                             flash[:alert] = @error
                         end
                 else
                   
                        res       = @donation.make_donation_call(@donation.prepare_array_for_api)
                        
                        @response = @donation.response_result(res)
                     # raise @response.inspect
                        if @response['acknowledgement']=="Success"
                            @donation.transaction_id = @response['transactionId']
                            @donation.save
                            flash[:notice] = "Donation request has been successfully submitted"
                           # redirect_to dashboard_path
                            redirect_to donation_detail_path(@donation) and return 
                        else
                           @error =  @response['friendlyErrorMessage']
                           flash[:alert] = @error 
                        end
               
                end
            end
         rescue Timeout::Error,Errno::ETIMEDOUT ,Errno::EINVAL, Errno::ECONNRESET, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
           flash[:alert] =  "Connection error occured. Please try again later."
          end #begin end

      end #valid end

    end

  end
  
  def donation_apinonprofit
     @ein = params[:ein]
    
    unless @ein.blank?
      
    
    
    begin
      
   
    @result =  NonProfitSearchApi.search(@ein)
    
   # raise @result.inspect
    
               if !@result.blank?
                        if current_user.address.blank?
                hash = { :donor_id => current_user.id,
                  :email => current_user.email,
                  :card_type => "VI",
                  :amount    => 5.00
                }
              else
                @address = current_user.address
                hash =                     {    :donor_id => current_user.id,
                  :email    => current_user.email,
                  :address1 => @address.address1,
                  :address2 => @address.address2,
                  :city     => @address.city_name,
                  :state    => @address.state.state_code,
                  :zip_code => @address.zip_code,
                  :card_type => "VI",
                  :amount    => 5.00
          
                }
              end
    
    @api_nonprofit = ApiNonprofit.new(:ein => @result['government_id'],
                                      :uuid => @result['organization_uuid'],
                                      :name => @result['organization_name'],
                                      :state => @result['region'],
                                      :zip_code => @result['postal_code'],
                                      :address1 => @result['address_line_1'],
                                      :address2 => @result['address_line_2'],
                                      :city=> @result['city'],
                                      :phone_number=> @result['phone_number'],
                                      :full_address=> @result['address_full']
                                       )
      # raise @api_nonprofit.inspect
       @donation = @api_nonprofit.build_donation(hash)
       
       
               else
                redirect_to member_url("nonprofits"),:alert => "No nonprofit found" and return
               end
     
     
    
    rescue Timeout::Error,Errno::ETIMEDOUT, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      redirect_to new_user_registration_url ,:alert => "Connection error occured. Please try again later." and return
    end

    
    
    else
     redirect_to member_url("nonprofits"),:alert => "No nonprofit found"
    end
    
  end
 
  def create_donation_apinonprofit
     if !params[:api_nonprofit].blank?
     params[:api_nonprofit][:donation_attributes][:donor_id]         = current_user.id
     params[:api_nonprofit][:donation_attributes][:email]            = current_user.email
     params[:api_nonprofit][:donation_attributes][:description]      = "Donation via cauzly.com"
     params[:api_nonprofit][:donation_attributes][:donation_message] = "Donation via cauzly.com"
     params[:api_nonprofit][:donation_attributes][:country]          = "US"
     params[:api_nonprofit][:donation_attributes][:charity_id]       = params[:api_nonprofit][:uuid]
    @api_nonprofit = ApiNonprofit.new(params[:api_nonprofit])
      # raise @api_nonprofit.inspect
     @donation= @api_nonprofit.donation
    
     @donation.donor_ip     = request.remote_ip
     @donation.tracking_no  = rand(9999).to_s+Time.now.to_i.to_s+rand(9999).to_s # unique tracking_no
      
     #raise @donation.prepare_array_for_api.inspect
       if @api_nonprofit.valid?
            begin
            
             
      if @donation.use_card?
         #raise @donation.donor.card_token.card_token.inspect
                        
                                res       = @donation.make_donation_call_via_card_file(@donation.donation_param_card_on_file(@donation.donor.card_token.card_token ))
                                @response = @donation.response_result(res)
                                if @response['acknowledgement']=="Success"
                                    @donation.transaction_id = @response['transactionId']
                                    @donation.save
                                    @api_nonprofit.save 
                                    flash[:notice] = "Donation request has been successfully submitted"
                                   # redirect_to dashboard_path
                                    redirect_to donation_detail_path(@donation) and return 
                                else
                                   @error =  @response['friendlyErrorMessage'] #+ @response['verboseErrorMessage'] + @response.to_s +   @donation.donation_param_card_on_file(@donation.donor.card_token.card_token).to_s
                                   flash[:alert] = @error
                                   render "donation_apinonprofit"
                                end
                       
         
       else
            
            
             if @donation.future_use?
                      #raise @donation.card_on_file_prepare.inspect
                         res = @donation.make_cardonfile_call(@donation.card_on_file_prepare)
                         @cardon_file_response = @donation.response_result(res)
                        # raise @cardon_file_response.inspect
                         
                         if @cardon_file_response['acknowledgement']=="Success"
                                @card_token = @donation.donor.card_token || @donation.donor.build_card_token
                                @card_token.card_token = @cardon_file_response['cardOnFileId']
                                @card_token.save
                                
                                res       = @donation.make_donation_call_via_card_file(@donation.donation_param_card_on_file(@card_token.card_token))
                                @response = @donation.response_result(res)
                                if @response['acknowledgement']=="Success"
                                    @donation.transaction_id = @response['transactionId']
                                    @donation.save
                                    @api_nonprofit.save 
                                    flash[:notice] = "Donation request has been successfully submitted"
                                   # redirect_to dashboard_path
                                    redirect_to donation_detail_path(@donation) and return 
                                else
                                   @error =  @response['friendlyErrorMessage'] #+@response['verboseErrorMessage'] + "Donation with token" + @donation.donation_param_card_on_file(@card_token.card_token).to_s
                                   flash[:alert] = @error
                                   render "donation_apinonprofit"
                                end
                         else
                             @error =  @cardon_file_response['friendlyErrorMessage']
                             flash[:alert] = @error
                             render "donation_apinonprofit"
                         end
                 else
            
            
                        res       = @donation.make_donation_call(@donation.prepare_array_for_api)
                        
                        @response = @donation.response_result(res)
                     # raise @response.inspect
                        if @response['acknowledgement']=="Success"
                            @donation.transaction_id = @response['transactionId']
                            @donation.save
                            @api_nonprofit.save 
                            flash[:notice] = "Donation request has been successfully submitted"
                            #redirect_to dashboard_path
                           redirect_to donation_detail_path(@donation) and return 
                        else
                           @error =  @response['friendlyErrorMessage'] 
                           flash[:alert] = @error 
                           render "donation_apinonprofit"
                        end
                 end
               
         end  
    rescue Timeout::Error,Errno::ETIMEDOUT, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
     flash[:alert] =  "Connection error occured. Please try again later." 
     render "donation_apinonprofit"
    end
        
    else
      
        render "donation_apinonprofit"
    end
    else
      redirect_to api_nonprofitdonation_url(:uuid => params[:uuid],:ein => params[:ein]) 
    end
    
  end
  

end
