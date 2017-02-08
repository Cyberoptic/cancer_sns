json.array! @notifications do |notification|
  json.actor notification.actor.decorate.name
  json.actor_photo_url notification.actor.photo.url
  json.action notification.action
  json.read_at notification.read_at
  json.created_at notification.created_at

  notifiable_type = notification.notifiable.class.to_s == "Post" || notification.notifiable.class.to_s == "GroupPost" ? "投稿" : notification.notifiable.class.to_s

  json.notifiable do
    json.type "あなたの#{notifiable_type}"
  end
  json.url "/" + notification.notifiable.class.to_s.underscore.downcase + "s/" + (notification.notifiable_id).to_s
end