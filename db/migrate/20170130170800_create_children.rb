class CreateChildren < ActiveRecord::Migration[5.0]
  def change
    create_table :children do |t|
      t.integer :age
      t.integer :user_id
      t.timestamps
    end

    add_index :children, :user_id
  end
end
