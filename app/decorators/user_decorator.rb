class UserDecorator < Draper::Decorator
  delegate_all

  def display_name    
  	object.nickname.blank? ? name : object.nickname
  end	

  def name
  	"#{last_name}#{first_name}"
  end

  def introduction
    object.introduction.blank? ? "このユーザーは紹介文をまだ書いていません。" : object.introduction
  end

  def gender_icon
  	if object.gender == "男性"
  		'<i class="fa fa-male" aria-hidden="true"></i> 男性'.html_safe 
  	elsif object.gender == "女性"
  		'<i class="fa fa-female" aria-hidden="true"></i> 女性'.html_safe 
  	else
  		'<i class="fa fa-genderless" aria-hidden="true"></i> その他'.html_safe 
  	end
  end
end
