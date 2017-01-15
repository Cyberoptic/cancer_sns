require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }

  describe '.room_with' do
    let!(:chat_room) { create(:chat_room, user: user_1, member: user_2)}

    it 'should return chat_room' do
      expect(ChatRoom.room_with(user_1, user_2)).to eq(chat_room)
    end
  end
end
