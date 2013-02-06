class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.integer :user_id
      t.string :facebook
      t.string :twitter
      t.string :googleplus
      t.string :linkedin
      t.string  :youtube
      t.string :pinterest 
      t.string :foursquare 
      t.string :blog
      
      t.timestamps
    end
  end
end
