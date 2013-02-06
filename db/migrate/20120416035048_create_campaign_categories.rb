class CreateCampaignCategories < ActiveRecord::Migration
  def change
    create_table :campaign_categories do |t|
      t.string :name
      t.text :description
      t.string :slug

      t.timestamps
    end
  end
end
