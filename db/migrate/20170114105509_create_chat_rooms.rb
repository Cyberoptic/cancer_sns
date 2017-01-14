class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.integer :member_id, index: true

      t.timestamps
    end

    add_foreign_key :chat_rooms, :users, column: :member_id
  end
end
