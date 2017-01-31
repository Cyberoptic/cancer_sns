class AddPrefectureToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :prefecture, :string
  end
end
