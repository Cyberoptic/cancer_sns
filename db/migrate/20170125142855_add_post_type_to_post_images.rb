class AddPostTypeToPostImages < ActiveRecord::Migration[5.0]
  def change
    add_column :post_images, :post_type, :string
  end
end
