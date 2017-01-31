class UserAttributesVisibilityPolicy
  def initialize(user:, attribute:, current_user:)
    @user = user
    @current_user = current_user
    @attribute = attribute
  end

  def visible?
    return true if @current_user == @user
    return true if visible_to_everyone? && @user[@attribute].present? 
    visible_to_friends? && @current_user.friends_with?(@user) && @user[@attribute].present?
  end

  private

  def visible_to_everyone?
    @user["#{@attribute}_visibility"] == User::SETTING_OPTIONS[0]
  end

  def visible_to_friends?
    @user["#{@attribute}_visibility"] == User::SETTING_OPTIONS[1]
  end
end