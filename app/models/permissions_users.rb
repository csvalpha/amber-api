class PermissionsUsers < ApplicationRecord
  belongs_to :user
  belongs_to :permission

  validates :user, presence: true
  validates :permission, presence: true
end
