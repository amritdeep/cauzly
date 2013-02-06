class CreateActivityFeeds < ActiveRecord::Migration
  def change
    create_table :activity_feeds do |t|
      t.integer :user_id
      t.integer :activity_source_id
      t.string :activity_source_type

      t.timestamps
    end
  end
end
