class NotifierMailer < ApplicationMailer
  def new_message(message)
    @message = message
    @other_user = @message.chat_room.other_user_for(@message.user)

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @other_user.email, subject: "【Cancer Partners】#{@message.user.decorate.display_name}さんからの新しいメッセージ")
  end

  def daily_message_digest(user)
    @user = user
    @messages = user.unread_messages

    @has_updates = @messages.count > 0 || user.has_new_comments_or_replies_in_last_day?

    subject = @has_updates ? "【Cancer Partners】新しいメッセージ/コメントがあります" : "【Cancer Partners】新しいメッセージ/コメントはありません"

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @user.email, subject: subject)
  end

  def new_comment(comment:, user:)
    @comment = comment
    @user = user

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @user.email, subject: "【Cancer Partners】あなたの投稿に対して新しいコメントがあります")
  end

  def new_reply(comment:, user:)
    @comment = comment
    @user = user

    mail(from: "Cancer Partners <no-reply@cancer-partners.com>", to: @user.email, subject: "【Cancer Partners】あなたがコメントした投稿に新しいコメントがあります")
  end
end
