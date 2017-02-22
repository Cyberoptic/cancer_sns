class Message < ApplicationRecord
  acts_as_readable on: :created_at

  belongs_to :user
  belongs_to :chat_room, touch: true

  validates :body, presence: true
  after_create_commit { MessageBroadcastJob.perform_later(self) }
  after_create :set_read_for_current_user!

  delegate :photo, to: :user, prefix: true

  def timestamp
    created_at.strftime('%-m/%d %H:%M')
  end

  def set_read_for(user_id:)
    user = User.find(user_id)
    self.mark_as_read! for: user
    ReadStatusBroadcastJob.perform_later(message: self, user: chat_room.other_user_for(user))
  end  

  private

  def set_read_for_current_user!
    self.mark_as_read! for: user
  end

end
