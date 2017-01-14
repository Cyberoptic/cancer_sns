class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @chat_room = ChatRoom.includes(messages: :user).find_by(id: params[:id])
    @message = Message.new
  end
end