class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)    
    ActionCable.server.broadcast "chat_rooms_#{message.chat_room.user.id}_channel",
                                  {
                                    chat_room_id: message.chat_room.id,
                                    sender_id: message.user.id,
                                    message_snippet: message.body.truncate(25),
                                    message: render_message(message)
                                  }

    ActionCable.server.broadcast "chat_rooms_#{message.chat_room.member.id}_channel",
                                  {
                                    chat_room_id: message.chat_room.id,
                                    sender_id: message.user.id,
                                    message_snippet: message.body.truncate(25),
                                    message: render_message(message)
                                  }
  end

  private

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message.decorate}
  end
end