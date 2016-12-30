class Sad < ApplicationRecord
	belongs_to :user
	belongs_to :post, counter_cache: true

	validates :user_id, :post_id, presence: true

	validates :user_id, uniqueness: {scope: :post_id}
end
