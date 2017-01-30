class Child < ApplicationRecord
  belongs_to :user
  validates :age, presence: true
end
