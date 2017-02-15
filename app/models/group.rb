require 'elasticsearch/model'

class Group < ApplicationRecord
  include Searchable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  mount_uploader :photo, GroupPhotoUploader
  
  validates :name, presence: true
  has_many :group_posts, dependent: :destroy
  has_many :group_memberships, dependent: :destroy

  scope :order_by_group_membership_counts, ->{ order(group_memberships_count: :desc) }
  scope :order_by_created_at, ->{ order(created_at: :desc) }
end
