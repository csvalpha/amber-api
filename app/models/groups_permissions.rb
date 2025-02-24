class GroupsPermissions < ApplicationRecord
  has_paper_trail
  belongs_to :group
  belongs_to :permission
end
