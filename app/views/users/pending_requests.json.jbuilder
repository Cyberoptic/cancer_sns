json.array! @requests do |request|
  json.id request.id  
  json.created_at "#{time_ago_in_words(request.created_at)}前"
  json.friendable_id request.friendable_id
  json.friendable_first_name request.friendable.first_name
  json.friendable_last_name request.friendable.last_name  
  json.friendable_photo_url request.friendable.photo.url
end
