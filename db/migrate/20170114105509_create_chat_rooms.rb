class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.integer :member_id, index: true

      t.timestamps
    end

    add_foreign_key :chat_rooms, :users, column: :member_id

    HasFriendship::Friendship.all.each do |request|
      initiator = User.find_by_id(request.friendable_id)
      member = User.find_by_id(request.friend_id)
      chat_room = ChatRoom.room_with(initiator, member)
      unless chat_room.present?
        ChatRoom.create!(user: initiator, member: member)
      end
    end
  end
end
