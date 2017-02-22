class MessageDecorator < Draper::Decorator
  decorates_association :user, with: UserDecorator
  delegate_all

  def body
    if object.photo
      "【画像】"
    else
      object.body
    end
  end
end
