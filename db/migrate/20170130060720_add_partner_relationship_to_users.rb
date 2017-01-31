class AddPartnerRelationshipToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :partner_relationship, :string
  end
end
