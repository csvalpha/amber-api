class GroupsPermissions < ApplicationRecord
  belongs_to :group
  belongs_to :permission
end
