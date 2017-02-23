class UserDecorator < Draper::Decorator
  delegate_all  

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_name    
  	object.nickname.blank? ? name : object.nickname
  end	

  def to_param
    object.to_param
  end

  def treatment
    treatment = ""    
    treatment += object.treatments.map do |treatment|
      next if treatment.name == "その他被保険療法"
      treatment.name
    end.join("<br/>")
    treatment += "その他被保険療法（#{object.other_treatment}）" if object.other_treatment.present?
    treatment.html_safe
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
