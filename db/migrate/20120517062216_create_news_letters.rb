class CreateNewsLetters < ActiveRecord::Migration
  def change
    create_table :news_letters do |t|
      t.integer :user_type_id,:default => 0
      t.string :subject
      t.text :body
      t.integer :sent_status,:default => 0

      t.timestamps
    end
  end
end
