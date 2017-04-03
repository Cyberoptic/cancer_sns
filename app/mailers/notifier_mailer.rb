class NotifierMailer < ApplicationMailer
  def new_message(message)
    @message = message
    @other_user = @message.chat_room.other_user_for(@message.user)

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @other_user.email, subject: "【Cancer Partners】#{@message.user.decorate.display_name}さんからの新しいメッセージ")
  end

  def daily_message_digest(user)
    @user = user
    @messages = user.unread_messages
    subject = @messages.count > 0 ? "【Cancer Partners】新しいメッセージがあります" : "【Cancer Partners】新しいメッセージはありません"

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @user.email, subject: subject)
  end
end
