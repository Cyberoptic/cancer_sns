class CommentDecorator < Draper::Decorator
	decorates_association :user, with: UserDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
