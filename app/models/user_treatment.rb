class UserTreatment < ApplicationRecord
  belongs_to :user
  belongs_to :treatment

  # validates :user_id, uniqueness: {scope: :treatment_id}
  
  accepts_nested_attributes_for :treatment
end
