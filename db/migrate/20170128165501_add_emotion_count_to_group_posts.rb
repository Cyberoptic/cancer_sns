class AddEmotionCountToGroupPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :group_posts, :sads_count, :integer, default: 0
    add_column :group_posts, :happies_count, :integer, default: 0
    add_column :group_posts, :likes_count, :integer, default: 0
  end
end
