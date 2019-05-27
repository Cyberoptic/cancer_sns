require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'after_create' do
    context 'when the send_notification_as_batch setting of the user is set to false' do
      it 'sends a notification email' do
        user = create(:user, settings: {send_notification_as_batch: false})
        chat_room = create(:chat_room, user: user, member: create(:user))
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(NotifierMailer).to receive(:new_message).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_now)

        create(:message, user: user, chat_room: chat_room)

        expect(NotifierMailer).to have_received(:new_message)
        expect(message_delivery).to have_received(:deliver_now)
      end
    end

    context 'when the send_notification_as_batch setting of the user is set to true' do
      it 'does not send a notification email' do
        user = create(:user, settings: {send_notification_as_batch: true})
        chat_room = create(:chat_room, user: user, member: create(:user))
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        allow(NotifierMailer).to receive(:new_message).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_now)

        create(:message, user: user, chat_room: chat_room)

        expect(NotifierMailer).to_not have_received(:new_message)
        expect(message_delivery).to_not have_received(:deliver_now)
      end
    end
  end
end
