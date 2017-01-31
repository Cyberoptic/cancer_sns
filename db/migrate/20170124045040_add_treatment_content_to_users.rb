class AddTreatmentContentToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :treatment_content, :text
  end
end
