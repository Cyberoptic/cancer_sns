class CreateUserTreatments < ActiveRecord::Migration[5.0]
  def change
    create_table :user_treatments do |t|
      t.integer :user_id
      t.integer :treatment_id

      t.timestamps
    end
    add_index :user_treatments, :user_id
    add_index :user_treatments, :treatment_id
    add_index :user_treatments, [:user_id, :treatment_id]
  end
end
