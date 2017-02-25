require 'elasticsearch/model'

class Group < ApplicationRecord
  include Searchable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  mount_uploader :photo, GroupPhotoUploader
  
  validates :name, presence: true

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :group_posts, dependent: :destroy
  has_many :group_memberships, dependent: :destroy  
  has_many :accepted_group_memberships, -> {where(status: :accepted)}, class_name: "GroupMembership"
  has_many :pending_group_memberships, -> {where(status: :pending)}, class_name: "GroupMembership"
  has_many :moderators, -> {where(group_memberships: { role: :moderator })}, through: :group_memberships, source: :user

  scope :order_by_group_membership_counts, ->{ order(group_memberships_count: :desc) }
  scope :order_by_created_at, ->{ order(created_at: :desc) }
  scope :is_public, -> {where(is_public: true)}

  enum access_type: [:accessible_to_everyone, :needs_owner_permission]
end
