class CreateGroupPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :group_posts do |t|
      t.text :content
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
    add_index :group_posts, [:user_id, :group_id] 
    add_index :group_posts, :group_id
  end
end
