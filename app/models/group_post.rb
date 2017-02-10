class GroupPost < ApplicationRecord
  acts_as_readable on: :created_at
  
  belongs_to :group
  belongs_to :user
  has_many :comments, as: :post 
  has_many :post_images, as: :post
  has_many :emotions, as: :post
  
  accepts_nested_attributes_for :post_images

  validates :content, :user, :group_id, presence: true

  default_scope { order(created_at: :desc) }

  delegate :photo, to: :user, prefix: true

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
