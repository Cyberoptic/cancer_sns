class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images #dependent destroy
  has_many :likes, dependent: :destroy
  has_many :sads, dependent: :destroy
  has_many :happies, dependent: :destroy
  
  accepts_nested_attributes_for :post_images

  validates :content, :user, presence: true

  default_scope { order(created_at: :desc) }

  delegate :photo, to: :user, prefix: true
end
