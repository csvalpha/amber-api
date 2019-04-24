class V1::PermissionsUsersResource < V1::ApplicationResource
  has_one :permission
  has_one :user
end
