class AddRoleToGroupMembership < ActiveRecord::Migration[5.0]
  def change
    add_column :group_memberships, :role, :integer, default: 0, index: true
  end
end
