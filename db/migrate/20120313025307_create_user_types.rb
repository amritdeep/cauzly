class CreateUserTypes < ActiveRecord::Migration
  def change
    create_table :user_types do |t|
      t.string :name
      t.boolean :is_deleted,:default => false
      
      t.timestamps
    end
  end
end

