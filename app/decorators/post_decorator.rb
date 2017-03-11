class PostDecorator < Draper::Decorator
	decorates_association :user, with: UserDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def class
    object.class
  end

  def created_at
    object.created_at.strftime("%m/%d/%Y %l:%M %p")
  end
end
