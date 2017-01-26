class AddRecipientIdToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :recipient_id, :integer
  end
end
