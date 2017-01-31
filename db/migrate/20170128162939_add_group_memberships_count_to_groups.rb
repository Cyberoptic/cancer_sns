class AddGroupMembershipsCountToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :group_memberships_count, :integer, default: 0
  end
end
