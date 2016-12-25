class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images #dependent destroy
  accepts_nested_attributes_for :post_images

  validates :content, :user, presence: true

  scope :newest_first, ->{order(created_at: :desc)}
end
