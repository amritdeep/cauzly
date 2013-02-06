class StateCode < ActiveRecord::Migration
 def change
      add_column :states, :state_code, :string
 end
end
