class CreateReservedUsernames < ActiveRecord::Migration
  def change
    create_table :reserved_usernames do |t|
      t.string :username
      t.integer :user_id
      t.timestamps
    end
  end
end
