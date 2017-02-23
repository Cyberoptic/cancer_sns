class PostImage < ApplicationRecord
  belongs_to :post, optional: true, polymorphic: true
  belongs_to :user

  mount_uploader :photo, CommentPhotoUploader
  validates :photo, :post, :user, presence: true
end
