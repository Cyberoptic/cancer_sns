class CreatePostImages < ActiveRecord::Migration[5.0]
  def change
    create_table :post_images do |t|
      t.string :photo
      t.integer :post_id
      t.integer :user_id
      t.timestamps
    end

    add_index :post_images, :post_id
    add_index :post_images, :user_id

  end
end
