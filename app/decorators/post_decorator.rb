class PostDecorator < Draper::Decorator
	decorates_association :user, with: UserDecorator
  def self.collection_decorator_class
    PaginatingDecorator
  end
  delegate_all
end