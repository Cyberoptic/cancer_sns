class GroupPost < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :comments, as: :post
  has_many :post_images, as: :post
  has_many :likes, as: :post, dependent: :destroy
  has_many :sads, as: :post, dependent: :destroy
  has_many :happies, as: :post, dependent: :destroy
  
  accepts_nested_attributes_for :post_images

  validates :content, :user, :group, presence: true

  default_scope { order(created_at: :desc) }

  delegate :photo, to: :user, prefix: true
end
