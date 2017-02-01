class EmotionDecorator < Draper::Decorator
  decorates_association :user, with: UserDecorator
  delegate_all
end