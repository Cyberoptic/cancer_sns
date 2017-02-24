class CreatePostTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :post_taggings do |t|
      t.integer :post_tag_id, index: true
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
