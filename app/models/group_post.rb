class GroupPost < ApplicationRecord
  acts_as_readable on: :created_at
  
  belongs_to :group
  belongs_to :user
  has_many :comments, as: :post 
  has_many :post_images, as: :post
  has_many :emotions, as: :post
  has_many :post_taggings, as: :post
  has_many :post_tags, through: :post_taggings
  
  accepts_nested_attributes_for :post_images
  accepts_nested_attributes_for :post_taggings, allow_destroy: true, reject_if: proc { |attributes| attributes['post_id'].blank? }
  
  validates :content, :user, :group_id, presence: true

  default_scope { order(created_at: :desc) }

  delegate :photo, to: :user, prefix: true

  def self.tagged_with(name)
    PostTag.find_by_name(name).group_posts.includes(:user, :post_images, :post_taggings, :post_tags)
  end

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
