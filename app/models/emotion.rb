class Emotion < ApplicationRecord  
  belongs_to :user
  belongs_to :post, polymorphic: true, foreign_key: "post_id", counter_cache: true

  validates :user_id, uniqueness: {scope: :post_id}
  validates :user_id, :post_id, presence: true

  enum emotion: {like: 0, happy: 1, sad: 2, mad: 3} 

  delegate :photo, to: :user, prefix: true

  after_create :notify_recipient
  # after_create :notify_group_recipient #### breaks the code

  private 

  def notify_recipient
    Notification.create({ recipient: self.post.user, actor: self.user, action: "#{self.emotion}s", notifiable: self.post }) if self.user != self.post.user
  end

  def notify_group_recipient
    Notification.create({ recipient: self.group_post.user, actor: self.user, action: "#{self.emotion}s", notifiable: self.group_post }) if self.user != self.group_post.user
  end 
end
