module Emotionable
  extend ActiveSupport::Concern

  included do
    has_many :emotions
  end

  def emotioned_on?(post)
    post.emotions.pluck(:user_id).include?(self.id)    
  end

  def like(post)
    emotion = emotions.find_or_initialize_by(post: post)
    if emotion.emotion == "like"
      emotion.destroy
    elsif emotion.new_record?
      emotion.emotion = "like"
      emotion.save!
    else
      emotion.update(emotion: "like")
    end
  end

  def sad(post)
    emotion = emotions.find_or_initialize_by(post: post)
    if emotion.emotion == "sad"
      emotion.destroy
    elsif emotion.new_record?
      emotion.emotion = "sad"
      emotion.save!
    else
      emotion.update(emotion: "sad")
    end
  end

  def happy(post)
    emotion = emotions.find_or_initialize_by(post: post)
    if emotion.emotion == "happy"
      emotion.destroy
    elsif emotion.new_record?
      emotion.emotion = "happy"
      emotion.save!
    else
      emotion.update(emotion: "happy")
    end
  end

  def mad(post)
    emotion = emotions.find_or_initialize_by(post: post)
    if emotion.emotion == "mad"
      emotion.destroy
    elsif emotion.new_record?
      emotion.emotion = "mad"
      emotion.save!
    else
      emotion.update(emotion: "mad")
    end
  end

  def unlike(post)
    emotions.find_by(post: post, emotion: "like").destroy
  end

  def unsad(post)
    emotions.find_by(post: post, emotion: "sad").destroy
  end

  def unhappy(post)
    emotions.find_by(post: post, emotion: "happy").destroy
  end

  def unmad(post)
    emotions.find_by(post: post, emotion: "mad").destroy
  end

  def liked?(post)
    post.emotions.likes.pluck(:user_id).include?(self.id)
  end

  def sadded?(post)   
    post.emotions.sads.pluck(:user_id).include?(self.id) 
  end

  def happied?(post)
    post.emotions.happies.pluck(:user_id).include?(self.id)
  end

  def madded?(post)
    post.emotions.mads.pluck(:user_id).include?(self.id)
  end
end
