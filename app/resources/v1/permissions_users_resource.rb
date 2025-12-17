# frozen_string_literal: true

class V1::PermissionsUsersResource < V1::ApplicationResource
  self.model = PermissionsUsers

  with_timestamps

  has_one :permission
  has_one :user, resource: V1::UserResource
end
