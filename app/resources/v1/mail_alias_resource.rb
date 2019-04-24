class V1::MailAliasResource < V1::ApplicationResource
  attributes :email, :moderation_type, :description

  has_one :group, always_include_linkage_data: true
  has_one :user, always_include_linkage_data: true
  has_one :moderator_group, always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[email moderation_type moderator_group description group user]
  end

  def self.searchable_fields
    %i[email description]
  end
end
