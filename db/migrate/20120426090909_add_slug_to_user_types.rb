class AddSlugToUserTypes < ActiveRecord::Migration
  def change
    add_column :user_types, :slug, :string
  end
end
