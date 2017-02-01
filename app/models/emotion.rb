class Emotion < ApplicationRecord  
  belongs_to :user
  belongs_to :post, polymorphic: true, foreign_key: "post_id", counter_cache: true

  validates :user_id, uniqueness: {scope: :post_id}
  validates :user_id, :post_id, presence: true

  enum emotion: {like: 0, happy: 1, sad: 2, mad: 3}
end
