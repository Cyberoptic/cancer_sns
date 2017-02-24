class NotifiableSlackJob < ApplicationJob
  queue_as :default

  def perform(text:, username: "ユーザー登録通知", channel:)
    Slack.chat_postMessage(text: text, username: username, channel: channel)
  end
end
