class V1::GroupsPermissionsResource < V1::ApplicationResource
  has_one :permission
  has_one :group
end
