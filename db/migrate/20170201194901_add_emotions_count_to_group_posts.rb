class AddEmotionsCountToGroupPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :group_posts, :emotions_count, :integer, default: 0, null: false
  end
end
