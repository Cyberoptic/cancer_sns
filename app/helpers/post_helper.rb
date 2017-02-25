module PostHelper
  def visibility_icon(visibility)
    if visibility == "公開"
      '<i class="fa fa-globe" aria-hidden="true"></i>'.html_safe
    elsif visibility == "友達にのみ公開"
      '<i class="fa fa-users" aria-hidden="true"></i>'.html_safe
    else
      '<i class="fa fa-lock" aria-hidden="true"></i>'.html_safe
    end
  end
end  