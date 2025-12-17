# frozen_string_literal: true

class V1::UserResource < V1::ApplicationResource # rubocop:disable Metrics/ClassLength
  self.model = User

  with_timestamps

  # Basic attributes (always visible)
  attribute :username, :string, writable: false
  attribute :first_name, :string do
    writable do
      user_can_create_or_update?
    end
  end
  attribute :last_name_prefix, :string do
    writable do
      user_can_create_or_update?
    end
  end
  attribute :last_name, :string do
    writable do
      user_can_create_or_update?
    end
  end
  attribute :full_name, :string, writable: false
  attribute :nickname, :string

  # Avatar attributes (always visible)
  attribute :avatar_url, :string, writable: false do
    @object.avatar.url
  end
  attribute :avatar_thumb_url, :string, writable: false do
    @object.avatar.thumb.url
  end
  attribute :avatar, :string, readable: false # Write-only for uploads

  # Conditional attributes - only visible if update_or_me?
  attribute :login_enabled, :boolean do
    readable { update_or_me? }
    writable { user_can_create_or_update? && !me? }
  end
  attribute :otp_required, :boolean do
    readable { update_or_me? }
    writable { me? }
  end
  attribute :activated_at, :datetime do
    readable { update_or_me? }
    writable false
  end
  attribute :emergency_contact, :string do
    readable { update_or_me? }
  end
  attribute :emergency_number, :string do
    readable { update_or_me? }
  end
  attribute :ifes_data_sharing_preference, :string do
    readable { update_or_me? }
    writable { me? }
  end
  attribute :info_in_almanak, :boolean do
    readable { update_or_me? }
    writable { me? }
  end
  attribute :almanak_subscription_preference, :string do
    readable { update_or_me? }
  end
  attribute :digtus_subscription_preference, :string do
    readable { update_or_me? }
  end
  attribute :user_details_sharing_preference, :string do
    readable { update_or_me? }
    writable { me? }
  end
  attribute :allow_sofia_sharing, :boolean do
    readable { update_or_me? }
    writable { me? }
  end
  attribute :sidekiq_access, :boolean do
    readable { update_or_me? }
    writable { me? }
  end
  attribute :setup_complete, :boolean do
    readable { update_or_me? }
    writable { me? }
  end

  # Attributes visible if read_or_me?
  attribute :picture_publication_preference, :string do
    readable { read_or_me? }
    writable { me? }
  end

  # Attributes visible if read_user_details? (and not sofia)
  attribute :email, :string do
    readable { read_user_details_or_sofia? }
  end
  attribute :birthday, :date do
    readable { read_user_details_or_sofia? }
    writable { user_can_create_or_update? }
  end
  attribute :address, :string do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :postcode, :string do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :city, :string do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :phone_number, :string do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :food_preferences, :string do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :vegetarian, :boolean do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :study, :string do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :start_study, :integer do
    readable { read_user_details? && !application_is_sofia? }
  end
  attribute :trailer_drivers_license, :boolean do
    readable { read_user_details? && !application_is_sofia? }
  end

  # iCal attributes (only me)
  attribute :ical_secret_key, :string do
    readable { me? }
    writable false
  end
  attribute :ical_categories, :array do
    readable { me? }
    writable { me? }
  end

  # Password (write-only)
  attribute :password, :string, readable: false do
    writable { me? }
  end

  # Relationships
  has_many :groups
  has_many :active_groups, resource: V1::GroupResource
  has_many :memberships
  has_many :mail_aliases
  has_many :mandates, resource: V1::Debit::MandateResource
  has_many :group_mail_aliases, resource: V1::MailAliasResource
  has_many :permissions
  has_many :photos
  has_many :user_permissions, resource: V1::PermissionsUsersResource

  # Filters
  filter :upcoming_birthdays, :boolean do
    eq do |scope, value|
      next scope unless value

      upcoming_birthdays = scope.upcoming_birthdays
      scope.find_each do |record|
        unless read_user_details_for_record?(record)
          upcoming_birthdays = upcoming_birthdays.where.not(id: record.id)
        end
      end
      upcoming_birthdays
    end
  end

  filter :me, :boolean do
    eq do |scope, value|
      next scope unless value

      scope.where(id: current_user_or_application&.id)
    end
  end

  filter :group, :string do
    eq do |scope, value|
      scope.active_users_for_group(Group.find_by(name: value))
    end
  end

  searchable_fields :email, :first_name, :last_name, :last_name_prefix, :nickname, :study

  # Callbacks
  before_save only: [:create] do |model|
    model.activation_token = User.activation_token_hash[:activation_token]
    model.activation_token_valid_till = User.activation_token_hash[:activation_token_valid_till]
    model.username = model.generate_username
  end

  after_commit only: [:create] do |model|
    UserMailer.account_creation_email(model).deliver_later if model.login_enabled
  end

  # Scope with eager loading for index
  def base_scope
    scope = super
    if Graphiti.context[:action] == 'index'
      scope = scope.includes(:mandates)
    end
    scope
  end

  private

  def read_or_me?
    read_permission? || me?
  end

  def read_user_details?
    return false unless current_user

    @object.user_details_sharing_preference == 'all_users' ||
      (read_or_me? && @object.user_details_sharing_preference == 'members_only') ||
      me? || update_or_me?
  end

  def read_user_details_or_sofia?
    read_user_details? ||
      (application_is_sofia? && @object.allow_sofia_sharing)
  end

  def read_user_details_for_record?(record)
    record.user_details_sharing_preference == 'all_users' ||
      ((self.class.read_permission? || record == current_user) &&
       record.user_details_sharing_preference == 'members_only') ||
      record == current_user || self.class.update_permission?
  end

  def application_is_sofia?
    return false unless context&.key?(:application) && Graphiti.context[:application]

    Graphiti.context[:application].scopes.to_a.include?('sofia')
  end

  def update_or_me?
    self.class.update_permission? || me?
  end

  def me?
    @object == current_user
  end

  def user_can_create_or_update?
    self.class.user_can_create_or_update?
  end
end
