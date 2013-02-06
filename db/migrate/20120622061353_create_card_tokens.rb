class CreateCardTokens < ActiveRecord::Migration
  def change
    create_table :card_tokens do |t|
      t.string :card_token
      t.integer :user_id

      t.timestamps
    end
  end
end
