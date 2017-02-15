class AddNameToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :name, :string

    User.all.each do |user|
      full_name = "#{user.last_name}#{user.first_name}"
      user.update(name: full_name)
    end
  end

  def down
    remove_column :users, :name
  end
end
