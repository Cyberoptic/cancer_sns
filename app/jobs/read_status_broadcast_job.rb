class ReadStatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message:, user:)    
    ActionCable.server.broadcast "chat_rooms_#{user.id}_channel",
                                  {
                                    read_status_broadcast: true,
                                    chat_room_id: message.chat_room.id,
                                    sender_id: message.user.id,
                                    message_id: message.id
                                  }
  end
end
