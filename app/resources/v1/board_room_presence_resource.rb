class V1::BoardRoomPresenceResource < V1::ApplicationResource
  attributes :start_time, :end_time, :status

  has_one :user, always_include_linkage_data: true

  filter :current, apply: ->(records, _value, _options) { records.current }
  filter :future, apply: ->(records, _value, _options) { records.future }
  filter :current_and_future, apply: ->(records, _value, _options) { records.current_and_future }

  before_create do
    @model.user_id = current_user.id
  end

  def self.creatable_fields(_context)
    %i[start_time end_time status]
  end
end
