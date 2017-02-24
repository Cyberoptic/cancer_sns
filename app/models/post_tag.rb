class PostTag < ApplicationRecord
  has_many :post_taggings

  validates :name, presence: true
end
