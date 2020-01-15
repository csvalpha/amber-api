class V1::QuickpostStatisticResource < V1::ApplicationResource
  model_name 'QuickpostStatistic'
  attributes :user_id, :messages_total, :messages_last_month, :messages_last_week
end
