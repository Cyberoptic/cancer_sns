json.array! @notifications do |notification|
  # json.recipient notification.recipient
  json.actor notification.actor
  json.action notification.action
  # json.notifiable notification.notifiable
  json.notifiable do 
    # json.type "a comment" if notifiable.notifiable_type == "Comment"
    json.type "a post" if notification.notifiable_type == "Post"
    json.type "a group post" if notification.notifiable_type == "GroupPost"
    json.type "to you" if notification.notifiable_type == "User"
  end
  # notification.notifiable_type == "Post" ? json.url posts_path(anchor: notification.notifiable) : group_posts_path(anchor: notification.notifiable) 
end