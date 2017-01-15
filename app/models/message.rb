class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  validates :body, presence: true
  after_create_commit { MessageBroadcastJob.perform_later(self) }

  delegate :photo, to: :user, prefix: true

  def timestamp
    created_at.strftime('%-m/%d %H:%M:%S')
  end
end
