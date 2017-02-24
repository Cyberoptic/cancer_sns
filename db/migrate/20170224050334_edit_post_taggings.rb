class EditPostTaggings < ActiveRecord::Migration[5.0]
  def change
    remove_column :post_taggings, :user_id
    add_column :post_taggings, :post_id, :integer, index: true
  end
end
