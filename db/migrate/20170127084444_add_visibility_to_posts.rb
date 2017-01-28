class AddVisibilityToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :visibility, :integer, default: 0
  end
end
