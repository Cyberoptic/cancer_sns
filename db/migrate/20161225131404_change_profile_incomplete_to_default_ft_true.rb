class ChangeProfileIncompleteToDefaultFtTrue < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :profile_incomplete, :boolean, default: true, null: false
  end
end
