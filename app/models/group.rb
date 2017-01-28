class Group < ApplicationRecord
  validates :name, presence: true
  has_many :group_posts, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
end
