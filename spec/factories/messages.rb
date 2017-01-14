FactoryGirl.define do
  factory :message do
    body "MyText"
    user nil
    chat_room nil
  end
end
