require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }

  describe '#room_with' do
    let!(:chat_room) { create(:chat_room, user: user_1, member: user_2)}

    it 'should return chat_room' do
      expect(ChatRoom.room_with(user_1, user_2)).to eq(chat_room)
    end
  end

  describe "#last_message" do
    context "when there are no messages for the chat room" do
      it "returns nil" do
        chat_room = create(:chat_room, user: user_1, member: user_2)

        expect(chat_room.last_message).to eq(nil)
      end
    end

    context "when there are messages for the chat room" do
      it "returns the last message" do
        chat_room = create(:chat_room, user: user_1, member: user_2)
        message = create(:message, user: user_1, chat_room: chat_room, body: "first message")
        message_2 = create(:message, user: user_1, chat_room: chat_room, body: "last message")

        expect(chat_room.last_message).to eq("last message")
      end
    end    
  end

  describe "#last_active_at" do
    context "when there are no messages for the chat room" do
      it "returns nil" do
        chat_room = create(:chat_room, user: user_1, member: user_2)

        expect(chat_room.last_active_at).to eq(nil)
      end
    end

    context "when there are messages for the chat room" do
      it "returns the last active at time" do
        chat_room = create(:chat_room, user: user_1, member: user_2)
        message = create(:message, user: user_1, chat_room: chat_room, body: "first message")
        message_2 = create(:message, user: user_1, chat_room: chat_room, body: "last message", created_at: DateTime.now - 1.minute)

        expect(chat_room.last_active_at).to eq("1分前")
      end
    end
  end

  describe "#other_user_for" do
    context "when argument is user" do
      it "returns the member" do
        chat_room = create(:chat_room, user: user_1, member: user_2)

        expect(chat_room.other_user_for(user_1)).to eq(user_2)
      end
    end

    context "when argument is member" do
      it "returns the user" do
        chat_room = create(:chat_room, user: user_1, member: user_2)

        expect(chat_room.other_user_for(user_2)).to eq(user_1)
      end
    end
  end
end
