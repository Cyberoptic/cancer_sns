class RemoveRecepientIdFromNotifications < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :recepient_id, :integer
  end
end
