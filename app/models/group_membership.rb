class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group, counter_cache: true

  validates :group_id, uniqueness: {scope: :user_id}

  delegate :photo, to: :user, prefix: true

  enum role: {member: 0, moderator: 1}
end
