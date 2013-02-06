class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.integer :state_id
      t.string :city_name
      t.string :zip_code
      t.string :address1
      t.string :address2

      t.timestamps
    end
  end
end
