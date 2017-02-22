class AddPublicToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :is_public, :boolean, default: true, null: false
  end
end
