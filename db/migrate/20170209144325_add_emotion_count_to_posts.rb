class AddEmotionCountToPosts < ActiveRecord::Migration[5.0]
  def up
    add_column :group_posts, :sads_count, :integer, default: 0
    add_column :group_posts, :happies_count, :integer, default: 0
    add_column :group_posts, :likes_count, :integer, default: 0
    add_column :group_posts, :mads_count, :integer, default: 0
    add_column :posts, :sads_count, :integer, default: 0
    add_column :posts, :happies_count, :integer, default: 0
    add_column :posts, :likes_count, :integer, default: 0
    add_column :posts, :mads_count, :integer, default: 0

    Post.all.each do |post|
      post.emotions.each do |emotion|        
        post["#{emotion.emotion.pluralize}_count"] += 1
      end
      post.save
    end

    GroupPost.all.each do |post|
      post.emotions.each do |emotion|
        post["#{emotion.emotion.pluralize}_count"] += 1
      end
      post.save
    end
  end

  def down
    remove_column :group_posts, :sads_count, :integer
    remove_column :group_posts, :happies_count, :integer
    remove_column :group_posts, :likes_count, :integer
    remove_column :group_posts, :mads_count, :integer
    remove_column :posts, :sads_count, :integer
    remove_column :posts, :happies_count, :integer
    remove_column :posts, :likes_count, :integer
    remove_column :posts, :mads_count, :integer
  end
end
