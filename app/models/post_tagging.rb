class PostTagging < ApplicationRecord
  belongs_to :post_tag
  belongs_to :post, polymorphic: true, foreign_key: :post_id, optional: true
  
  validates :post, :post_tag_id, presence: true
end
