FactoryGirl.define do
  factory :post do
    content 'Hello there this is a content'
    factory :invalid_post do
      content ''
    end
  end
end
