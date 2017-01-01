class Comment < ApplicationRecord
	default_scope { order(created_at: :desc) }

	validates :text, :user_id, :post_id, presence: true
	belongs_to :user
	belongs_to :post

	delegate :display_name, :photo, to: :user, prefix: true
	delegate :user, to: :post, prefix: true	

end
