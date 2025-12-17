# frozen_string_literal: true

class V1::MailAliasResource < V1::ApplicationResource
  self.model = MailAlias

  with_timestamps

  attribute :email, :string
  attribute :moderation_type, :string
  attribute :description, :string
  attribute :smtp_enabled, :boolean
  attribute :last_received_at, :datetime do
    readable { update_permission? }
    writable false
  end

  has_one :group
  has_one :user, resource: V1::UserResource
  has_one :moderator_group, resource: V1::GroupResource

  searchable_fields :email, :description
end
