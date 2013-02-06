class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :user_id
      t.integer :campaign_category_id
      t.string :title
      t.text :description
      t.datetime :end_date
      t.boolean :is_deleted
      t.string :slug
      t.timestamps
    end
    
    add_index :campaigns, :slug
    add_index :campaigns, :campaign_category_id
  end
end
