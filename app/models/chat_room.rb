class ChatRoom < ApplicationRecord
  belongs_to :user
  belongs_to :member, class_name: 'User'
  has_many :messages, dependent: :destroy

  scope :most_recent, -> {order(updated_at: :desc).first}

  scope :user_with_name, -> (name) { joins(:user).where("LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ?", "#{name[0..2]}%", "#{name[0..2]}%")}
  scope :member_with_name, -> (name) { joins(:member).where("LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ?", "#{name[0..2]}%", "#{name[0..2]}%")}

  def other_user_for(current_user) 
    return member if current_user == user
    user
  end

  def self.find_with_name(name)
    (
      user_with_name(name) + member_with_name(name)
    ).uniq
  end

  def self.room_with(user, member)
    all.where(user: user, member: member).first ||  all.where(user: member, member: user).first
  end
end
