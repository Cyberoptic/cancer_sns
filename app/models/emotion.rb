class Emotion < ApplicationRecord  
  belongs_to :user
  belongs_to :post, polymorphic: true, foreign_key: "post_id", counter_cache: true

  validates :user_id, uniqueness: {scope: :post_id}
  validates :user_id, :post_id, presence: true

  enum emotion: {like: 0, happy: 1, sad: 2, mad: 3} 

  delegate :photo, to: :user, prefix: true

  after_create :notify_recipient

  private 

  def notify_recipient
    Notification.create({ recipient: self.post.user, actor: self.user, action: "#{self.emotion}", notifiable: self.post }) if self.user != self.post.user
  end
end
