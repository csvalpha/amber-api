class PermissionsUsers < ApplicationRecord
  has_paper_trail
  belongs_to :user
  belongs_to :permission
end
