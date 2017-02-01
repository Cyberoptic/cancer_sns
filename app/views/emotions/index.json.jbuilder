json.array! @emotions do |emotion|
  json.user_name emotion.user.display_name
  json.user_link "/users/#{emotion.user.to_param}"
  json.user_photo_url emotion.user.photo.url
  json.emotion_image_url "assets/svgs/#{emotion.emotion.emotion}.svg"
end
