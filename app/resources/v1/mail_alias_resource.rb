class V1::MailAliasResource < V1::ApplicationResource
  attributes :email, :moderation_type, :description, :smtp_enabled, :last_received_at

  has_one :group, always_include_linkage_data: true
  has_one :user, always_include_linkage_data: true
  has_one :moderator_group, class_name: 'Group', always_include_linkage_data: true

  def fetchable_fields
    return super - [:last_received_at] unless update_permission?

    super
  end

  def self.creatable_fields(_context)
    %i[email moderation_type moderator_group description smtp_enabled group user]
  end

  def self.searchable_fields
    %i[email description]
  end
end
