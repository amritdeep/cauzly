class ActivitySourceObserver < ActiveRecord::Observer
  observe  :user_post,:campaign,:donation
 
    def after_create(activity_source)
     
      if activity_source.is_a?Donation
         user_id = activity_source.donor.id
      else  
        user_id = activity_source.user.id
       end
      ActivityFeed.create!(
        :user_id => user_id ,
        :activity_source_id => activity_source.id,
        :activity_source_type => activity_source.class.to_s,
        :created_at => activity_source.created_at,
        :updated_at => activity_source.updated_at)
    end
   
    def after_update(activity_source)
       if activity_source.is_a?UserPost
        
         ActivityFeed.destroy_all(:activity_source_id => activity_source.id)
      else  
      
      end
    end
    def before_destroy(activity_source)
      ActivityFeed.destroy_all(:activity_source_id => activity_source.id)
    end
end
