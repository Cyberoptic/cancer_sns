json.array! @notifications do |notification|
  json.actor notification.actor.decorate.display_name
  json.actor_photo_url notification.actor.photo.url

  if %w(Post GroupPost).include?(notification.notifiable.class.to_s)
    action = "に#{notification.action}"    
    type = "あなたの投稿"
  elsif %w(Group).include?(notification.notifiable.class.to_s)
    action = "#{notification.action}"    
    type = ""
  end

  json.action action
  json.read_at notification.read_at
  json.created_at notification.created_at

  json.notifiable do
    json.type type
  end
  json.url "/" + notification.notifiable.class.to_s.underscore.downcase + "s/" + (notification.notifiable_id).to_s
end