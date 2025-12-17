# frozen_string_literal: true

class V1::GroupsPermissionsResource < V1::ApplicationResource
  self.model = GroupsPermissions

  with_timestamps

  has_one :permission
  has_one :group
end
