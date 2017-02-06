class AddHashIdToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
    add_column :users, :hash_id, :string, index: true
    User.all.each{|m| m.set_hash_id!; m.save}
  end
  def down
    remove_column :users, :hash_id, :string
  end
end
