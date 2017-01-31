class AddVisibleToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :visible, :boolean, default: true, null: false
  end
end
