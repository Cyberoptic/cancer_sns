class RemoveEmotions < ActiveRecord::Migration[5.0]
  def change
    drop_table :happies unless table_exists? :happies
    drop_table :sads unless table_exists? :sads
    drop_table :likes unless table_exists? :likes
    remove_column :posts, :happies_count
    remove_column :posts, :likes_count
    remove_column :posts, :sads_count
    remove_column :group_posts, :happies_count
    remove_column :group_posts, :likes_count
    remove_column :group_posts, :sads_count
  end
end
