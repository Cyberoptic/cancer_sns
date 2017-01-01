json.array! @requests do |request|
  json.id request.id  
  json.friendable_id request.friend_id
  json.friendable_first_name request.friendable.first_name
  json.friendable_last_name request.friendable.last_name  
end
