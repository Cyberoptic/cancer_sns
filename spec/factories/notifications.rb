FactoryGirl.define do
  factory :notification do
    recipient_id 1
    actor_id 1
    action "MyString"
    notifiable_id 1
    notifiable_type "MyString"
  end
end
