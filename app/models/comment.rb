class Comment < ApplicationRecord
  mount_uploader :photo, CommentPhotoUploader

	default_scope { order(created_at: :desc) }

	validates :user_id, :post_id, presence: true

  with_options if: :photo_is_empty? do |user|
    user.validates :text, presence: true
  end
  
	belongs_to :user
	belongs_to :post, polymorphic: true, touch: true
  has_many :emotions, as: :post, dependent: :destroy

	delegate :photo, to: :user, prefix: true
	delegate :user, to: :post, prefix: true

  scope :visible, ->{ where(visible: true) }

  after_create :create_notifications

  def toggle_visibility!
    self.visible = !visible
    save
  end

  def delete!
    update(deleted_at: DateTime.now)
  end

  def deleted?
    deleted_at.present?
  end

  private

  def photo_is_empty?
    photo.url.nil?
  end

  def create_notifications
    notify_commenters

    notify_post_owner    
  end

  def notify_commenters
    post.comments.map(&:user).uniq.each do |comment_user|      
      Notification.create({recipient: comment_user, actor: self.user, action: "コメント", notifiable: self}) unless (comment_user == self.user)
    end
  end

  def notify_post_owner
    Notification.create({recipient: self.post.user, actor: self.user, action: "コメント", notifiable: self.post}) unless self.post.comments.pluck(:user_id).include?(self.post.user.id)
  end
end
