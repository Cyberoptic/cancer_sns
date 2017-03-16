class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group, counter_cache: true

  validates :user, uniqueness: {scope: :group, message: 'はもうすでにメンバーか招待済みです。'}
  validates :user_id, :group_id, presence: true

  delegate :photo, to: :user, prefix: true

  enum role: {member: 0, moderator: 1}
  enum status: [:accepted, :pending, :invited]

  scope :moderating, -> { where(role: :moderator) }
end