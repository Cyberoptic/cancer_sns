class CreateSads < ActiveRecord::Migration[5.0]
  def change
    create_table :sads do |t|
    	t.references :user
      t.references :post
      t.timestamps
    end
  end
end
