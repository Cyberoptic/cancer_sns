class AddEmotionsCountToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :likes_count, :integer, default: 0
    add_column :comments, :emotions_count, :integer, default: 0

    Comment.update_all(likes_count: 0, emotions_count: 0)
  end
end
