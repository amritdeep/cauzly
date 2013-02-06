Cauzly::Application.routes.draw do
  
  
  
  

  

 

  get "invites/index"
    get "invites/invite_email"
      post "invites/invite_email"

  devise_for :users, :controllers => {:registrations => "registrations" } do
    match  'not_me' => 'registrations#not_me', :as => :not_me 
    match 'users/sign_up/fbinvite'=>'registrations#fbinvite',:as=> :fb_invite
  end
  get 'follow/user/:id' => 'follow#follow', :as => 'follow_user'
  get 'dashboard/(:id)/follower' => 'follow#follower', :as => 'user_follower'
  get 'unfollow/user/:id' => 'follow#unfollow', :as => 'unfollow_user'
  get 'block/follower/:id' => 'follow#block', :as => 'block_follower'
  get 'dashboard/(:id)/following' => 'follow#following', :as => 'user_following'
   
  
  match  'dashboard' => 'dashboard#index', :as => :dashboard 
  match 'dashboard/profile' => 'dashboard#my_profile',:as => :dashboard_profile
  match  'dashboard/update/address' => 'dashboard#update_address', :as => :user_address_update 
  match  'dashboard/update/payment_receiving_info' => 'dashboard#payment_receiving_info', :as => :payment_receiving_info 
  match 'dashboard/update/profile'=> 'dashboard#update_profile', :as => :update_profile
  match 'dashboard/images'   => 'dashboard#images',:as => :userimages
  match 'dashboard/videos'   => 'dashboard#videos',:as => :uservideos
  
  match 'dashboard/claim_username/:claim' => 'dashboard#claim_request' ,:as => :claim_request
  
  match 'home/pages/:page_id' => 'home#show_page', :as => :pages_contents
  
  resources :user_images
  resources :user_posts
  #resources :user_videos
 resources :settings do
   
   collection do  
    get 'changepassword'
    post 'updatepassword'
    get 'social_accounts' => "authentications#index"
   end
 end
 
 match 'get_nonprofit_from_api' => "nonprofit_search#get_nonprofit_from_api",:as => :get_nonprofit_from_api
 match 'details_donations_made' => "donation_details#details_donations_made", :as => :details_donations_made
 match 'details_donations_received' => "donation_details#details_donations_received", :as => :details_donations_received
 match 'find_non_profits' => "home#find_non_profits", :as => :find_nonprofits
  
  scope "dashboard" do
    resources :campaigns,:controller =>"user_campaigns", :as => "user_campaigns" do 
     #resources :cause_images
     member do
        post 'addimage'
        delete 'removeimage/:campaign_image_id' => "user_campaigns#removeimage" ,:as => :removeimage
        
        post 'addvideo'
        delete 'removevideo/:campaign_video_id' => "user_campaigns#removevideo" ,:as => :removevideo
        
        get "donations_campaigns"
        
      end
    end
  end
  
  
  resources :campaign_categories


  resources :members do 
    member do  
      match 'index/:letter' => 'members#members_index' ,:as => :members_index
      scope ':state_id' do 
        match '' => 'members#members_state' ,:as => :members_state
        match 'index/:letter' => 'members#members_state_index' ,:as => :members_state_index
      end
    end
    collection do 
      get 'filter_by_state_and_type'
      post 'filter_by_state_and_type'
    end
  end
  
  
  
 
resources :search do 
   collection do
       
      match 'causes' => "search#causes",:as => :cause
      match 'causes/:key' => "search#cause_results" ,:as => :cause_result
      
      match 'members' => 'search#members' ,:as => :members
      match 'members/:letter' => 'search#members_index' ,:as => :members_index
   end
  end
  
  
  
  resources :campaigns do
    
    collection do 
    get "filter"
    post "filter"
    match '/category/:id' => "campaigns#campaigns_by_category",:as => :by_category
    match '/filter/:sort_order'=> "campaigns#sort_order" ,:as => :filter_sort
    match ':sort_order/state/:state_id'=> "campaigns#state_sort" ,:as => :filter_state_sort
    match ':sort_order/:category_id' => "campaigns#category_sort" ,:as => :filter_category_sort
    match ':sort_order/:category_id/:state_id' => "campaigns#category_state_sort" ,:as => :filter_category_state_sort
      
    end
    get :autocomplete_campaign_title, :on => :collection
    
    collection do
      get "listed_featured_campaign"
    end
    
   end
  
  
  
  
  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'
  
  #devise_for :users  
  resources :authentications
  
  
  #match 'dashboard/update/nonprofit_profile'  => 'dashboard#nonprofit_profile',:as => :nonprofit_profile_update
  #match 'dashboard/update/sponsor_profile'  => 'dashboard#sponsor_profile',:as => :sponsor_profile_update
  #match 'dashboard/update/donor_profile'  => 'dashboard#donor_profile',:as => :donor_profile_update
  match 'dashboard/update/avatar' => 'dashboard#update_logo', :as => :update_logo
  match 'dashboard/update/sociallinks' => 'dashboard#update_social_links', :as => :social_link_update
  match 'dashboard/update/profile_url' => 'dashboard#update_profile_name',:as => :profile_name_update
 
  match 'donors/(:filter)' => 'home#donors' ,:as => :donors
  match 'sponsors/(:filter)' => 'home#sponsors' ,:as => :sponsors
  match 'users/(:filter)' => 'home#users' ,:as => :users
  
  match 'members'    => 'home#search',:as => :member_search
   
  match 'donation_detail/:donation_id' => "profile#share_donation", :as => :donation_detail
  
  resources :donations 
  match 'makedonation/campaign/:campaign_id' => "donations#new" ,               :as => :campaign_donation
  match 'makedonation/user/:user_id'         => "donations#new" ,               :as => :user_donation 
  match 'makedonation/apiuser/:ein'          =>"donation#unregistered_donation",:as => :apiuser_donation
  
  match 'donation/apinonprofit/:uuid/:ein' => "donations#donation_apinonprofit" ,:as => :api_nonprofitdonation
  match 'makedonation/apinonprofit/:uuid/:ein' => "donations#create_donation_apinonprofit" ,:as => :api_createnonprofitdonation
  
  # The priority is based upon order of creation:t
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  namespace :admin do
    match  'dashboard' => 'dashboard#index', :as => :dashboard 
    match  'individual_donation' => 'users#donations', :as => :individual_donation
    match  'campaign_donation' => 'campaigns#campaign_donations', :as => :campaign_donation
    match 'apinonprofit_donations' => 'users#api_nonprofitdonations' ,:as => :api_nonprofitdonation
    resources :campaigns do 
      member do
        get "add_to_featured"
        get "removed_from_featured"
       
      end
      
      collection do
    get "featured_campaigns"
       end
      
      
    end
    resources :states
    resources :cities
    resources :featured_users
     resources :pages
    resources :news_letters do 
      member do 
        get "send_news_letter"
      end
     
    end
   resources :reserved_usernames do
   get "approve_request"
   get "reject_request"
 
   end
   
   
   
   
    resources :users do 
    
       get 'campaigns'
      collection do 
      get 'search'
      post 'search'
      get 'filter_by_state_and_type'
      post 'filter_by_state_and_type'
    get 'bytype/:user_type_id'  => 'users#user_filter_by_type', :as => 'user_filter_by_type'
    get 'filter(/:state_id)(/:user_type_id)' => 'users#user_filter', :as => 'user_filter'
    end
       
    end
     
    
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => "home#index"
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  scope '/:id' do
    match "/" =>"profile#index" , :as => :profile  
    
    match "campaigns" => "profile#campaigns" ,:as => :profile_campaigns
    match "videos" => "profile#videos" ,:as => :profile_videos
    match "images" => "profile#images" ,:as => :profile_images
    match 'follower' => 'profile#follower',:as => :profile_follower
    match 'following' => 'profile#following',:as => :profile_following
    
    match'campaigns/:campaign_id' => "profile#campaign_detail" ,:as => :user_campaign_detail
  end

end
