class Createpage < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :page_title
      t.string :page_name
      t.text :page_content
      t.string :slug
      t.integer :page_order
      t.timestamps
    end
     add_index :pages, :slug
  end
end
