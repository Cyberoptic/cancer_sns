class UserDecorator < Draper::Decorator
  delegate_all

  def display_name
  	object.nickname.empty? ? name : object.nickname
  end	

  def name
  	"#{last_name}#{first_name}"
  end

  def gender_icon
  	if object.gender == "男性"
  		'<i class="fa fa-male" aria-hidden="true"></i>'.html_safe 
  	elsif object.gender == "女性"
  		'<i class="fa fa-female" aria-hidden="true"></i>'.html_safe 
  	else
  		'<i class="fa fa-genderless" aria-hidden="true"></i>'.html_safe 
  	end
  end

end
