class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  layout 'chat_layout'  

  def index
    @chat_room = current_user.chat_rooms.includes(messages: :user).most_recent 
    @chat_rooms = current_user.chat_rooms.includes(:member, :user, :messages).select{|chat_room| chat_room != @chat_room}
    @message_search = MessageSearch.new(params[:message_search])
    @message = Message.new
    @other_user = @chat_room.other_user_for(current_user).decorate if @chat_room.present?

    mark_messages_as_read
  end

  def show
    @chat_room = ChatRoom.includes(messages: :user).find(params[:id])
    @chat_rooms = current_user.chat_rooms.includes(:member, :user, :messages).select{|chat_room| chat_room != @chat_room}    
    @message = Message.new    
    @message_search = MessageSearch.new(params[:message_search])
    @other_user = @chat_room.other_user_for(current_user).decorate      
    
    mark_messages_as_read
  end

  def create
    user = User.find(params[:user_id])

    if existing_chat_room = ChatRoom.room_with(user, current_user)
      return redirect_to chat_room_path(existing_chat_room)
    end

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
    return if !@chat_room.present? || @chat_room.messages.empty?
    @chat_room.messages.each{|message| message.mark_as_read! for: current_user}
  end
end