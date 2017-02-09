class EmotionLink
  PAST_TENSE_EMOTIONS = {
    like: :liked,
    happy: :happied,
    sad: :sadded,
    mad: :madded
  }
  
  def initialize(post:, emotion:, user:)
    @post = post
    @emotion = emotion
    @user = user
  end

  def url
    "#{@post.class.name.underscore}_#{@emotion.pluralize}_path"
  end 

  private

  def emotion_past_tense
    PAST_TENSE_EMOTIONS[@emotion.to_sym]
  end
end