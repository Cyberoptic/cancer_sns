class GroupPost < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :comments
  has_many :post_images, as: :post #dependent destroy
  has_many :likes, dependent: :destroy
  has_many :sads, dependent: :destroy
  has_many :happies, dependent: :destroy
  
  accepts_nested_attributes_for :post_images

  validates :content, :user, :group, presence: true

  default_scope { order(created_at: :desc) }

  delegate :photo, to: :user, prefix: true
end
