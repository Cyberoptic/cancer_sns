class Treatment < ApplicationRecord
  validates :name, presence: true
  validates_uniqueness_of :name
  has_many :user_treatments

  scope :default, -> { where(default: true) }
end
