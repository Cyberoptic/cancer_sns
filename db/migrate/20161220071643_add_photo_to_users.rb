class AddPhotoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :photo, :string
  end
end
