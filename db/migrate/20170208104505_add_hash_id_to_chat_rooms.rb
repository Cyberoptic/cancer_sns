class AddHashIdToChatRooms < ActiveRecord::Migration[5.0]
  def up
    add_column :chat_rooms, :slug, :string
    add_index :chat_rooms, :slug, unique: true
    add_column :chat_rooms, :hash_id, :string, index: true
    ChatRoom.all.each{|m| m.set_hash_id!; m.save}
  end
  def down
    remove_column :chat_rooms, :hash_id, :string
  end
end
