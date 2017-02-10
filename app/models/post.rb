class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :post
  has_many :post_images, as: :post
  has_many :emotions, as: :post, dependent: :destroy
  
  accepts_nested_attributes_for :post_images

  validates :content, :user, presence: true

  default_scope { order(created_at: :desc) }
  scope :visible_to_everyone, ->{ where(visibility: 0) }
  scope :visible_to_friends, -> { where(visibility: 1) }

  delegate :photo, to: :user, prefix: true

  enum visibility: {公開: 0, 友達にのみ公開: 1, 非公開: 2}

  def has_likes?
    likes_count > 0
  end

  def has_mads?
    mads_count > 0
  end

  def has_happies?
    happies_count > 0
  end

  def has_sads?
    sads_count > 0
  end
end
