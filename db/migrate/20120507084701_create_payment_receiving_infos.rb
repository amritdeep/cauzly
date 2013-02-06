class CreatePaymentReceivingInfos < ActiveRecord::Migration
  def change
    create_table :payment_receiving_infos do |t|
      t.integer :user_id
      t.string :email

      t.timestamps
    end
  end
end
