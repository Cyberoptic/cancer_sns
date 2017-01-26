class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :recepient_id
      t.integer :actor_id
      t.datetime :read_at
      t.string :action
      t.integer :notifiable_id
      t.string :notifiable_id

      t.timestamps
    end
  end
end
