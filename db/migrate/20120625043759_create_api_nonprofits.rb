class CreateApiNonprofits < ActiveRecord::Migration
  def change
    create_table :api_nonprofits do |t|
      t.string :name
      t.string :uuid
      t.string :ein
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :full_address
      t.string :phone_number

      t.timestamps
    end
  end
end
