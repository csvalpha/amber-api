class V1::SidekiqResource < V1::ApplicationResource
  has_one :permission
  has_one :user
end
