class EmotionLink
  PAST_TENSE_EMOTIONS = {
    like: :liked,
    happy: :happied,
    sad: :sadded
  }.freeze

  def initialize(post:, emotion:, user:)
    @post = post
    @emotion = emotion
    @user = user
  end

  def url
    if @user.send("#{emotion_past_tense}?", @post)
      "#{@post.class.name.underscore}_un#{@emotion.pluralize}_path"
    else  
      "#{@post.class.name.underscore}_#{@emotion.pluralize}_path"
    end
  end 

  private

  def emotion_past_tense
    PAST_TENSE_EMOTIONS[@emotion.to_sym]
  end
end