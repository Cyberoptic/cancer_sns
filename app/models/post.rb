class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :post_images #dependent destroy
  validates :content, :user, presence: true
end
