class PostTag < ApplicationRecord
  has_many :post_taggings
  has_many :posts, through: :post_taggings

  validates :name, presence: true

  def self.counts
    self.select("name, count(post_taggings.post_tag_id) as count").joins(:post_taggings).group("post_tags.name")
  end
end
