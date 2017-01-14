class ChatRoom < ApplicationRecord
  belongs_to :user
  belongs_to :member, class_name: 'User'
  has_many :messages, dependent: :destroy

  def self.room_with(user, member)
    all.where(user: user, member: member).first ||  all.where(user: member, member: user).first
  end
end
