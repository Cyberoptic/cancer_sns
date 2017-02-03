class AddReadAtToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :read_at, :datetime
  end
end
