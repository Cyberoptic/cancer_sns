FactoryGirl.define do
  factory :notification do
    recepient_id 1
    actor_id 1
    read_at "2017-01-19 15:40:42"
    action "MyString"
    notifiable_id 1
    notifiable_id "MyString"
  end
end
