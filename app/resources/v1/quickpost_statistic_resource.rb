class V1::QuickpostStatisticResource < V1::ApplicationResource
  attributes :user_id, :messages_total, :messages_last_month, :messages_last_week

  # has_one :user, always_include_linkage_data: true
end
