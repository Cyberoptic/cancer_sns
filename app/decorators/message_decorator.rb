class MessageDecorator < Draper::Decorator
  decorates_association :user, with: UserDecorator
  delegate_all

  def body
    if object.photo && object.body.empty?
      "【画像】"
    else
      object.body
    end
  end
end
