json.array! @notifications do |notification|
  json.actor notification.actor.decorate.display_name
  json.actor_photo_url notification.actor.photo.url

  if notification.action == "コメントに反応"
    action = "に反応"
    type = "があなたのコメント"
  elsif %w(Post GroupPost).include?(notification.notifiable.class.to_s)
    action = "に#{notification.action}"    
    type = "があなたの投稿"
  elsif %w(Group).include?(notification.notifiable.class.to_s)
    action = "#{notification.action}"    
    type = "が"
  elsif notification.notifiable.is_a? Comment
    action = "に#{notification.action}"
    type = "も#{notification.notifiable.post.user.decorate.display_name}さんの投稿"
  end

  if notification.notifiable.is_a? Comment
    notifiable_class = notification.notifiable.post.class.to_s.underscore.downcase
  else
    notifiable_class = notification.notifiable.class.to_s.underscore.downcase
  end

  json.action action
  json.read_at notification.read_at
  json.created_at notification.created_at

  json.notifiable do
    json.type type
  end

  notifiable_id = notification.notifiable.try(:slug) ? notification.notifiable.slug : notification.notifiable.id

  json.url "/" + notifiable_class + "s/" + (notifiable_id).to_s
end