class AddPublicToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_public, :boolean, default: false, null: false
    add_index :users, :is_public
  end
end
