class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :videoable_id
      t.string  :videoable_type
      t.string  :video_title
      t.string :video_url

      t.timestamps
    end
  end
end
