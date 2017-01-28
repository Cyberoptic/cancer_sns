module Emotionable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    belongs_to :post, polymorphic: true, foreign_key: "post_id", counter_cache: true

    validates :user_id, :post_id, presence: true

    validates :user_id, uniqueness: {scope: :post_id}
  end
end
