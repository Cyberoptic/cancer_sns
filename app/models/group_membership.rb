class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group, counter_cache: true

  validates :group_id, uniqueness: {scope: :user_id}
  validates :user_id, :group_id, presence: true

  delegate :photo, to: :user, prefix: true

  enum role: {member: 0, moderator: 1}
  enum status: [:accepted, :pending, :invited]

  scope :accepted, ->{where(status: :accepted)}
  scope :pending, ->{where(status: :pending)}
  scope :invited, ->{where(status: :invited)}
end