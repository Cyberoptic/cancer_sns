class AddPostTypeToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :post_type, :string
  end
end
