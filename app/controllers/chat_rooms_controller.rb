class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:message_search]
      @friends = current_user.friends.where("first_name LIKE ? OR last_name LIKE ? or nickname LIKE ?", "%#{params[:message_search][:name]}%", "%#{params[:message_search][:name]}%", "%#{params[:message_search][:name]}%")
    else
      @friends = current_user.friends
    end
    @message_search = MessageSearch.new(params[:message_search])
    @message = Message.new    
    @chat_rooms = ChatRoom.all    
    @chat_room = current_user.chat_rooms.includes(messages: :user).most_recent 
  end

  def show
    if params[:message_search]
      @friends = current_user.friends.where("first_name LIKE ? OR last_name LIKE ? or nickname LIKE ?", "%#{params[:message_search][:name]}%", "%#{params[:message_search][:name]}%", "%#{params[:message_search][:name]}%")
    else
      @friends = current_user.friends
    end
    @chat_room = ChatRoom.includes(messages: :user).find_by(id: params[:id])
    @message = Message.new    
    @message_search = MessageSearch.new(params[:message_search])
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:title)
  end
end