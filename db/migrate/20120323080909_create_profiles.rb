class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.text :additional_information
      t.string :website
      t.string :email
      t.string :phone
      t.boolean :qualified_501c
      

      t.timestamps
    end
  end
end
