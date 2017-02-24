class PostTag < ApplicationRecord
  has_many :post_taggings
  has_many :posts, through: :post_taggings, source: :post, source_type: "Post"
  has_many :group_posts, through: :post_taggings, source: :post, source_type: "GroupPost"

  validates :name, presence: true

  def self.counts
    self.select("name, count(post_taggings.post_tag_id) as count").joins(:post_taggings).group("post_tags.name")
  end
end
