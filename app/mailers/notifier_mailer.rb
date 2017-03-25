class NotifierMailer < ApplicationMailer
  def new_message(message)
    @message = message
    @other_user = @message.chat_room.other_user_for(@message.user)

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @other_user.email, subject: "#{@message.user.decorate.display_name}さんから新しいメッセージが届きました。")
  end

  def daily_message_digest(user)
    @user = user
    @messages = user.unread_messages

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @user.email, subject: "#{@messages.count}件の未読メッセージがあります。")
  end
end
