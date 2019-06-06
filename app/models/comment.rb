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
  after_create :send_emails

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

  def send_emails
    send_email_to_post_owner
    send_email_to_commenters
  end

  def send_email_to_post_owner
    return if self.post.user.send_notification_as_batch
    return if self.user_id === self.post.user_id
    NotifierMailer.new_comment(comment: self, user: self.post.user).deliver_now
  end

  def send_email_to_commenters
    post.comments.map(&:user).uniq.each do |comment_user|
      next if comment_user.id == post.user_id
      next if comment_user.id == self.user_id
      next if comment_user.send_notification_as_batch
      NotifierMailer.new_reply(comment: self, user: comment_user).deliver_now
    end
  end
end
