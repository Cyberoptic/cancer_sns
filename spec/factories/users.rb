FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@gmail.com"
  end

  factory :user do
    confirmed_at DateTime.now - 10.hours
    name "山本太郎"
    first_name "山本"    
		last_name "太郎"
    first_name_katakana "ヤマモト"
    last_name_katakana "タロウ"
    email { generate(:email) }
    password "Password123"
    password_confirmation "Password123"    
    birthday DateTime.now - 40.years
    area "北海道"
    prefecture "北海道"
    gender :男性
    partner_age 40
    partner_relationship "恋人"
    cancer_type "脳腫瘍"
    cancer_stage "ステージ１"
    profile_completed true
  end

  factory :incomplete_user, class: 'User' do
    confirmed_at DateTime.now - 10.hours
  	first_name "山本"    
		last_name "太郎"
		sequence :email do |n|
      "random#{n}@email.com"
    end
    password "Password123"
    password_confirmation "Password123"
  end  
end
