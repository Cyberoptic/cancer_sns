class AddSettingsToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :settings, :jsonb, null: false, default: {}
  end
end
