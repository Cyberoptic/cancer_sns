class AddPhotoToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :photo, :string
  end
end
