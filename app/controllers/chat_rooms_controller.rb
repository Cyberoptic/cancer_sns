class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_rooms = current_user.chat_rooms.includes(:member, :user)
    @message_search = MessageSearch.new(params[:message_search])
    @message = Message.new      
    @chat_room = current_user.chat_rooms.includes(messages: :user).most_recent 

    mark_messages_as_read
  end

  def show
    @chat_rooms = current_user.chat_rooms.includes(:member, :user)
    @chat_room = ChatRoom.includes(messages: :user).find_by(id: params[:id])
    @message = Message.new    
    @message_search = MessageSearch.new(params[:message_search])
    
    mark_messages_as_read
  end

  def create
    user = User.find(params[:user_id])
    @chat_room = ChatRoom.new(member: user, user: current_user)

    if @chat_room.save
      redirect_to chat_room_path(@chat_room)
    else
      flash[:alert] = @chat_room.errors.full_messages[0]
      redirect_to :back
    end
  end

  private

  def mark_messages_as_read
    return if @chat_room || @chat_room.messages.empty?
    @chat_room.messages.mark_as_read! :all, for: current_user
  end
end