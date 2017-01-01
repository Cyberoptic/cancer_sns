class Comment < ApplicationRecord

validates :text, :user_id, :post_id, presence: true
belongs_to :user
belongs_to :post

delegate :nickname, :photo, to: :user, prefix: true

end
