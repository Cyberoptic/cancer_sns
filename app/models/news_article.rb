class NewsArticle < ApplicationRecord
  default_scope { order(created_at: :desc) }

  validates :title, :content, presence: true

  mount_uploader :photo, NewsArticlePhotoUploader
end
