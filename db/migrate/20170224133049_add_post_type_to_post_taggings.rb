class AddPostTypeToPostTaggings < ActiveRecord::Migration[5.0]
  def change
    add_column :post_taggings, :post_type, :string, index: true
  end
end
