desc "This task is called by the Heroku scheduler add-on"
task send_batch_notifications: :environment do
  puts "Fetching users..."
  users = User.where(
            "users.settings->>:field = :value",
            field: "send_notification_as_batch",
            value: "true"
          )

  puts "#{users.count} users found."

  users.each do |user|    
    next if user.unread_messages.count == 0
    puts "Sending email to #{user.decorate.display_name}"
    NotifierMailer.daily_message_digest(user).deliver_now
  end

  puts "done."
end
