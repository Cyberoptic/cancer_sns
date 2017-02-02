class AddGenderToChildren < ActiveRecord::Migration[5.0]
  def change
    add_column :children, :gender, :integer
  end
end
