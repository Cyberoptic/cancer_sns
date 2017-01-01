class Comment < ApplicationRecord
	default_scope { order(created_at: :asc) }

	validates :text, :user_id, :post_id, presence: true
	belongs_to :user
	belongs_to :post

	delegate :photo, to: :user, prefix: true
	delegate :user, to: :post, prefix: true	

end
