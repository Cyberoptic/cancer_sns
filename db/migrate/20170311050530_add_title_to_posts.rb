class AddTitleToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :title, :string
  end
end
