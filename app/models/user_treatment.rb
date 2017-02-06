class UserTreatment < ApplicationRecord
  belongs_to :user
  belongs_to :treatment
  
  accepts_nested_attributes_for :treatment
end
