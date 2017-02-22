class AddAccessToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :access_type, :integer, default: 0, null: false
  end
end
