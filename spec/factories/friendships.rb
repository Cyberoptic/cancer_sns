FactoryGirl.define do
  factory :friendship, class: 'HasFriendship::Friendship' do
    friendable_type "User"
  end
end
