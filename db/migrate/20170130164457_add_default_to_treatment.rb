class AddDefaultToTreatment < ActiveRecord::Migration[5.0]
  def change
    add_column :treatments, :default, :boolean, null: false, default: false
  end
end
