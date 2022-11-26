class V1::UserResource < V1::ApplicationResource # rubocop:disable Metrics/ClassLength
  attributes :username, :first_name, :last_name_prefix, :last_name, :full_name,
             :login_enabled, :otp_required, :activated_at, :emergency_contact, :emergency_number,
             :ifes_data_sharing_preference, :info_in_almanak, :almanak_subscription_preference,
             :digtus_subscription_preference, :email, :birthday, :address, :postcode, :city,
             :phone_number, :food_preferences, :vegetarian, :study, :start_study,
             :picture_publication_preference, :ical_secret_key, :webdav_secret_key,
             :password, :avatar, :avatar_url, :avatar_thumb_url,
             :user_details_sharing_preference, :allow_tomato_sharing

  def avatar_url
    @model.avatar.url
  end

  def avatar_thumb_url
    @model.avatar.thumb.url
  end

  has_many :groups
  has_many :active_groups, class_name: 'Group'
  has_many :memberships
  has_many :mail_aliases
  has_many :mandates, class_name: 'Debit::Mandate', always_include_linkage_data: true
  has_many :group_mail_aliases, class_name: 'MailAlias'
  has_many :permissions
  has_many :user_permissions, class_name: 'Permission'

  filter :upcoming_birthdays, apply: lambda { |records, _value, options|
    context = options[:context]
    upcoming_birthdays = records.upcoming_birthdays
    records.find_each do |record|
      context[:model] = record
      unless read_user_details?(context)
        upcoming_birthdays = upcoming_birthdays.where.not(id: record.id)
      end
    end
    upcoming_birthdays
  }
  filter :me, apply: lambda { |records, _value, options|
    records.where(id: current_user_or_application(options))
  }
  filter :group, apply: lambda { |records, value, _options|
    records.active_users_for_group(Group.find_by(name: value))
  }

  # rubocop:disable all
  def fetchable_fields
    # Attributes
    allowed_keys = %i[username first_name last_name_prefix last_name full_name
                      avatar_url avatar_thumb_url created_at updated_at id]
    # Relationships
    allowed_keys += %i[groups active_groups memberships mail_aliases mandates
                       group_mail_aliases permissions user_permissions]
    allowed_keys += %i[ical_secret_key webdav_secret_key] if me?
    if update_or_me?
      allowed_keys += %i[login_enabled otp_required activated_at emergency_contact
                         emergency_number ifes_data_sharing_preference info_in_almanak
                         almanak_subscription_preference digtus_subscription_preference
                         user_details_sharing_preference allow_tomato_sharing]
    end
    allowed_keys += %i[picture_publication_preference] if read_or_me?
    if read_user_details? && !application_is_tomato?
      allowed_keys += %i[email birthday address postcode city phone_number food_preferences vegetarian
                         study start_study]
    end
    allowed_keys += %i[email birthday] if application_is_tomato? && @model.allow_tomato_sharing
    super && allowed_keys
  end
  # rubocop:enable all

  def self.creatable_fields(context) # rubocop:disable Metrics/MethodLength
    attributes = %i[avatar email address postcode city phone_number
                    food_preferences vegetarian study start_study
                    almanak_subscription_preference digtus_subscription_preference
                    emergency_contact emergency_number]
    if me?(context)
      attributes += %i[otp_required password
                       user_details_sharing_preference allow_tomato_sharing
                       picture_publication_preference info_in_almanak
                       ifes_data_sharing_preference]
    end

    if user_can_create_or_update?(context)
      attributes += %i[first_name last_name_prefix last_name birthday
                       user_permissions]
      attributes += [:login_enabled] unless me?(context)
    end
    attributes
  end

  def self.searchable_fields
    %i[email first_name last_name last_name_prefix study]
  end

  def self.records(options = {})
    options[:includes] = %i[mandates] if options[:context][:action] == 'index'
    super(options)
  end

  before_save do
    if @model.new_record?
      @model.activation_token = User.activation_token_hash[:activation_token]
      @model.activation_token_valid_till = User.activation_token_hash[:activation_token_valid_till]
      @model.username = @model.generate_username
    end
  end

  after_create do
    UserMailer.account_creation_email(@model).deliver_later if @model.login_enabled
  end

  def self.update_permission?(context)
    context[:user]&.permission?(:update, _model_class)
  end

  def self.read_permission?(context)
    context[:user]&.permission?(:read, _model_class)
  end

  def self.me?(context)
    context[:model] == context[:user]
  end

  def self.read_user_details?(context)
    context[:model].user_details_sharing_preference == 'all_users' ||
      ((read_permission?(context) || me?(context)) &&
      context[:model].user_details_sharing_preference == 'members_only') ||
      me?(context) || update_permission?(context)
  end

  private

  def read_or_me?
    read_permission? || me?
  end

  def read_user_details?
    current_user && (@model.user_details_sharing_preference == 'all_users' ||
      (read_or_me? && @model.user_details_sharing_preference == 'members_only') ||
      me? || update_or_me?)
  end

  def application_is_tomato?
    return false unless context.key?(:application) && context.fetch(:application)

    context.fetch(:application).scopes.to_a.include?('tomato')
  end

  def update_or_me?
    self.class.update_permission?(context) || me?
  end

  def me?
    @model == current_user
  end
end
