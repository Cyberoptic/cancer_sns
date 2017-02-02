class Comment < ApplicationRecord
	default_scope { order(created_at: :asc) }

	validates :text, :user_id, :post_id, presence: true
	belongs_to :user
	belongs_to :post, polymorphic: true

	delegate :photo, to: :user, prefix: true
	delegate :user, to: :post, prefix: true

  scope :visible, ->{ where(visible: true) }

  # creates notification for the recipient after actor comments
  after_create :notify_recipient

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

  def notify_recipient
    Notification.create({recipient: self.post.user, actor: self.user, action: "commented", notifiable: self.post}) if self.user != self.post.user
  end
end
