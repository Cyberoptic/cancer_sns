class CreateEmotions < ActiveRecord::Migration[5.0]
  def change
    create_table :emotions do |t|
      t.integer :emotion
      t.integer :user_id
      t.integer :post_id
      t.string :post_type

      t.timestamps
    end
    add_index :emotions, :user_id
    add_index :emotions, :post_id
    add_index :emotions, :post_type
    add_index :emotions, [:post_id, :post_type, :user_id]
    
  end
end
