class RemoveIsPublicFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :is_public
  end
end
