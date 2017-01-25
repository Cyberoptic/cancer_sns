class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_rooms = current_user.chat_rooms.includes(:member, :user)
    @message_search = MessageSearch.new(params[:message_search])
    @message = Message.new      
    @chat_room = current_user.chat_rooms.includes(messages: :user).most_recent 
  end

  def show
    @chat_rooms = current_user.chat_rooms.includes(:member, :user)
    @chat_room = ChatRoom.includes(messages: :user).find_by(id: params[:id])
    @message = Message.new    
    @message_search = MessageSearch.new(params[:message_search])
  end
end