class AddPartnerGenderToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :partner_gender, :integer
  end
end
