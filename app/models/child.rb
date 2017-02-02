class Child < ApplicationRecord
  belongs_to :user
  validates :age, presence: true

  enum gender: {男性: 0, 女性: 1, その他: 2}
end
