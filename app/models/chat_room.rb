class ChatRoom < ApplicationRecord
  belongs_to :user
  belongs_to :member, class_name: 'User'
  has_many :messages, dependent: :destroy
end
