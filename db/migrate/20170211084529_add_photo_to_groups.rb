class AddPhotoToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :photo, :string
  end
end
