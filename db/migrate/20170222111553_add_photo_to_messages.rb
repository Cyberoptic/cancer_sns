class AddPhotoToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :photo, :string
  end
end
