# frozen_string_literal: true

class V1::GroupsPermissionsResource < V1::ApplicationResource
  self.model = GroupsPermissions

  has_one :permission
  has_one :group
end
