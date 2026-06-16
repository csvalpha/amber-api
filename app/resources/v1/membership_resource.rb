# frozen_string_literal: true

class V1::MembershipResource < V1::ApplicationResource
  self.model = Membership

  with_timestamps

  attribute :start_date, :date
  attribute :end_date, :date
  attribute :function, :string

  has_one :user, resource: V1::UserResource
  has_one :group

  before_save do |model|
    model.start_date ||= Date.current
  end
end
