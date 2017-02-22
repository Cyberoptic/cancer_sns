class AddStatusToGroupMemberships < ActiveRecord::Migration[5.0]
  def change
    add_column :group_memberships, :status, :integer, default: 0, null: false
  end
end
