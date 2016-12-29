class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :post_images #dependent destroy
  accepts_nested_attributes_for :post_images

  validates :content, :user, presence: true

  default_scope { order(created_at: :desc) }

  delegate :photo, to: :user, prefix: true
end
