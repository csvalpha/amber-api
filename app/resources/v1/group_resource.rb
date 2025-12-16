# frozen_string_literal: true

class V1::GroupResource < V1::ApplicationResource
  self.model = Group

  attribute :name, :string do
    writable { user_can_create_or_update? }
  end
  attribute :avatar_url, :string, writable: false do
    @object.avatar.url
  end
  attribute :avatar_thumb_url, :string, writable: false do
    @object.avatar.thumb.url
  end
  attribute :description, :string do
    readable { current_user.present? }
  end
  attribute :description_camofied, :string, writable: false do
    readable { current_user.present? }
    camofy(@object['description'])
  end
  attribute :kind, :string do
    readable { current_user.present? }
    writable { user_can_create_or_update? }
  end
  attribute :recognized_at_gma, :date do
    readable { current_user.present? }
    writable { user_can_create_or_update? }
  end
  attribute :rejected_at_gma, :date do
    readable { current_user.present? }
    writable { user_can_create_or_update? }
  end
  attribute :administrative, :boolean do
    readable { current_user.present? }
    writable { user_can_create_or_update? }
  end
  attribute :avatar, :string, readable: false # Write-only for uploads

  has_many :users
  has_many :memberships
  has_many :mail_aliases
  has_many :permissions
  has_many :articles

  filter :active, :boolean do
    eq do |scope, value|
      value ? scope.active : scope
    end
  end

  filter :kind, :string

  filter :administrative, :boolean

  searchable_fields :name

  private

  def user_can_create_or_update?
    self.class.user_can_create_or_update?(context)
  end
end
