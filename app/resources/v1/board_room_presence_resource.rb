# frozen_string_literal: true

class V1::BoardRoomPresenceResource < V1::ApplicationResource
  self.model = BoardRoomPresence

  with_timestamps

  attribute :start_time, :datetime
  attribute :end_time, :datetime
  attribute :status, :string

  has_one :user, resource: V1::UserResource

  filter :current, :boolean do
    eq { |scope, value| value ? scope.current : scope }
  end

  filter :future, :boolean do
    eq { |scope, value| value ? scope.future : scope }
  end

  filter :current_and_future, :boolean do
    eq { |scope, value| value ? scope.current_and_future : scope }
  end

  before_save only: [:create] do |model|
    model.user_id = current_user.id
  end
end
