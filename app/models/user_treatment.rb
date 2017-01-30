class UserTreatment < ApplicationRecord
  belongs_to :user
  belongs_to :treatment
end
