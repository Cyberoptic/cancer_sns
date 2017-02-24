class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :post
  has_many :post_images, as: :post
  has_many :emotions, as: :post, dependent: :destroy
  has_many :post_taggings, as: :post
  has_many :post_tags, through: :post_taggings
  
  accepts_nested_attributes_for :post_images 
  accepts_nested_attributes_for :post_taggings, allow_destroy: true, reject_if: proc { |attributes| attributes['post_id'].blank? }

  validates :content, :user, presence: true

  default_scope { order(created_at: :desc) }
  scope :visible_to_everyone, ->{ where(visibility: 0) }
  scope :visible_to_friends, -> { where(visibility: 1) }
  scope :posts_by_friends_for, -> (user) { 
    where(user_id: user.friends.pluck(:id)).where("visibility = ? OR visibility = ?", 0, 1) 
  }

  delegate :photo, to: :user, prefix: true

  enum visibility: {公開: 0, 友達にのみ公開: 1, 非公開: 2}

  def self.visible_for(user)
    (
      visible_to_everyone.or(posts_by_friends_for(user)).or(where(user_id: user.id))
    ).uniq.includes(:user, :post_images, :post_taggings, :post_tags)
  end

  def self.tagged_with(name)
    PostTag.find_by_name(name).posts.includes(:user, :post_images, :post_taggings, :post_tags)
  end

  def tag_list
    post_tags.map(&:name).join(", ")
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
