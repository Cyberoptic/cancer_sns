class PostTagging < ApplicationRecord
  belongs_to :post_tag
  belongs_to :post, polymorphic: true, foreign_key: :post_id
  
  validates :post_id, :post_tag_id, presence: true
end
