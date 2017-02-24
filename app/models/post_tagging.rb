class PostTagging < ApplicationRecord
  belongs_to :post_tag
  belongs_to :post
  
  validates :post_id, :post_tag_id, presence: true
end
