class PostImage < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :user

  mount_uploader :photo, PhotoUploader
  validates :photo, :post, :user, presence: true
end
