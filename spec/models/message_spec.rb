require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'after_create' do
    it 'sends a notification email' do
      user = create(:user)
      chat_room = create(:chat_room, user: user, member: create(:user))
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      allow(NotifierMailer).to receive(:new_message).and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_later)

      create(:message, user: user, chat_room: chat_room)

      expect(NotifierMailer).to have_received(:new_message)
      expect(message_delivery).to have_received(:deliver_later)
    end
  end
end
