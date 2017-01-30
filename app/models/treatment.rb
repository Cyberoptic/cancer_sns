class Treatment < ApplicationRecord
  validates :name, presence: true
  validates_uniqueness_of :name, if: :default?  
  
  belongs_to :user
  has_many :user_treatments  

  scope :default, -> { where(default: true) }
end
