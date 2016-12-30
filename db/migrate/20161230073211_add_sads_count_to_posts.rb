class AddSadsCountToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sads_count, :integer, default: 0
  end
end
