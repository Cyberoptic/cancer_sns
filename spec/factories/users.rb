FactoryGirl.define do
  factory :user do
		first_name "山本"    
		last_name "太郎"
		sequence :email do |n|
      "random#{n}@email.com"
    end
    password "password"
    password_confirmation "password"
  end
end
