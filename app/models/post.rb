class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :post_images, as: :post #dependent destroy
  has_many :likes, dependent: :destroy
  has_many :sads, dependent: :destroy
  has_many :happies, dependent: :destroy
  
  accepts_nested_attributes_for :post_images

  validates :content, :user, presence: true

  default_scope { order(created_at: :desc) }
  scope :visible_to_everyone, ->{ where(visibility: 0) }
  scope :visible_to_friends, -> { where(visibility: 1) }

  delegate :photo, to: :user, prefix: true

  enum visibility: {公開: 0, 友達にのみ公開: 1, 非公開: 2}  
end
