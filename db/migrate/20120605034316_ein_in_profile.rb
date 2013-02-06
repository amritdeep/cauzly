class EinInProfile < ActiveRecord::Migration
  def change
   add_column :profiles, :ein, :string
   add_column :profiles, :charity_id, :string
  
  end
end
