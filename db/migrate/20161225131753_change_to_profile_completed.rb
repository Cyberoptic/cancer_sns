class ChangeToProfileCompleted < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :profile_incomplete
  	add_column :users, :profile_completed, :boolean, default: false, null: false
  end
end
