class PostImage < ApplicationRecord
  belongs_to :post
  belongs_to :user

  mount_uploader :photo, PhotoUploader
  validates :photo, :post, :user, presence: true
end
