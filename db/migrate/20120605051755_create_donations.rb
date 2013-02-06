class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :donor_id
      t.integer :donatable_id
      t.string  :donatable_type #campaigns,User(type_id=3),Unregistered_non-profits
      t.decimal :amount
      t.string  :tracking_no
      t.integer :donation_status
      t.string  :donor_ip
      t.text    :response_log
      t.string  :transaction_id

      t.timestamps
    end
  end
end
