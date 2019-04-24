class GroupsPermissions < ApplicationRecord
  belongs_to :group
  belongs_to :permission

  validates :group, presence: true
  validates :permission, presence: true
end
