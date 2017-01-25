class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:message_search]
      @chat_rooms = current_user.chat_rooms.find_with_name(params[:message_search][:name]).includes(:member, :user)
    else
      @chat_rooms = current_user.chat_rooms.includes(:member, :user)
    end
    @message_search = MessageSearch.new(params[:message_search])
    @message = Message.new      
    @chat_room = current_user.chat_rooms.includes(messages: :user).most_recent 
  end

  def show
    if params[:message_search]
      @chat_rooms = current_user.chat_rooms.find_with_name(params[:message_search][:name]).includes(:member, :user)
    else
      @chat_rooms = current_user.chat_rooms.includes(:member, :user)
    end
    @chat_room = ChatRoom.includes(messages: :user).find_by(id: params[:id])
    @message = Message.new    
    @message_search = MessageSearch.new(params[:message_search])
  end
end