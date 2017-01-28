class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group, counter_cache: true

  validates :group_id, uniqueness: {scope: :user_id}

end
