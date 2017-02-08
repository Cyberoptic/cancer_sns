class Message < ApplicationRecord
  acts_as_readable on: :created_at

  belongs_to :user
  belongs_to :chat_room, touch: true

  validates :body, presence: true
  after_create_commit { MessageBroadcastJob.perform_later(self) }
  after_create :set_read_for_current_user!

  delegate :photo, to: :user, prefix: true

  def timestamp
    created_at.strftime('%-m/%d %H:%M:%S')
  end

  private

  def set_read_for_current_user!
    self.mark_as_read! for: user
  end

end
