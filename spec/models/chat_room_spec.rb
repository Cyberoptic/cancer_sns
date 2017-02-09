require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }

  describe "does_not_have_duplicate_rooms" do
    context "chat room exists for users" do
      it "returns an error" do
        user = create(:user)
        other_user = create(:user)
        chat_room = create(:chat_room, user: user, member: other_user)

        new_chat_room = build(:chat_room, member: user, user: other_user)

        expect(new_chat_room).to_not be_valid
      end
    end

    context "chat room does not exist for users" do
      it "does not return an error" do
        user = create(:user)
        other_user = create(:user)

        chat_room = build(:chat_room, member: user, user: other_user)

        expect(chat_room).to be_valid
      end
    end
  end

  describe "#exists_for?" do
    context "chat room exists for users" do
      it "returns true" do
        user = create(:user)
        other_user = create(:user)
        chat_room = create(:chat_room, user: user, member: other_user) 

        expect(ChatRoom.exists_for?(user: user, member: other_user)).to eq(true)
        expect(ChatRoom.exists_for?(user: other_user, member: user)).to eq(true)
      end
    end

    context "chat room does not exist for users" do
      it "returns false" do
        user = create(:user)
        other_user = create(:user)

        expect(ChatRoom.exists_for?(user: user, member: other_user)).to eq(false)
        expect(ChatRoom.exists_for?(user: other_user, member: user)).to eq(false)
      end
    end
  end

  describe "hash_id" do
    context "when chat_room is created" do
      it "sets a hash_id" do
        chat_room = build(:chat_room, hash_id: nil, user: user_1, member: user_2)

        chat_room.save
        chat_room.reload

        expect(chat_room.hash_id).to_not be(nil)
      end
    end
  end

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
