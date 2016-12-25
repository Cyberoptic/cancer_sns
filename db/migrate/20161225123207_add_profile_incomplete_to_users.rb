class AddProfileIncompleteToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_incomplete, :boolean, default: false, null: false
    add_index :users, :profile_incomplete
  end
end
