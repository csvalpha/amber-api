require 'csv'

class User < ApplicationRecord # rubocop:disable Metrics/ClassLength
  has_one_time_password

  mount_base64_uploader :avatar, AvatarUploader
  has_paper_trail skip: %i[avatar]

  has_many :memberships, inverse_of: :user, dependent: :delete_all
  has_many :groups, through: :memberships
  has_many :active_groups, lambda {
    where('start_date <= :now AND (end_date > :now OR
      memberships.end_date IS NULL)', now: Time.zone.now)
  }, through: :memberships, source: :group
  has_many :permissions_users, class_name: 'PermissionsUsers', dependent: :delete_all
  has_many :user_permissions, through: :permissions_users, source: :permission
  has_many :article_comments, foreign_key: :author_id
  has_many :board_room_presences, dependent: :delete_all
  has_many :study_room_presences, dependent: :delete_all
  has_many :photo_comments, foreign_key: :author_id
  has_many :created_photo_tags, class_name: 'PhotoTag', foreign_key: :author_id,
                                dependent: :delete_all
  has_many :photo_tags, foreign_key: :tagged_user_id, dependent: :delete_all
  has_many :photos, through: :photo_tags
  has_many :mail_aliases, dependent: :delete_all
  has_many :read_threads, class_name: 'Forum::ReadThread', dependent: :delete_all
  has_many :mandates, class_name: 'Debit::Mandate', dependent: :delete_all
  has_many :transactions, class_name: 'Debit::Transaction', dependent: :delete_all
  has_many :group_mail_aliases, through: :active_groups, source: :mail_aliases

  # See https://github.com/doorkeeper-gem/doorkeeper#active-record
  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all

  has_secure_password(validations: false)
  # General fields
  validates :username, presence: true, uniqueness: true, format: { with: /\A[\w.]+\z/ }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, allow_nil: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :postcode, presence: true
  validates :city, presence: true
  validates :vegetarian, inclusion: [true, false]
  validates :phone_number, phone: { possible: true, allow_blank: true }

  # Technical fields
  validates :login_enabled, inclusion: [true, false]
  validate :password_when_activated?
  validate :allow_tomato_sharing_valid?

  # Preferences
  validates :almanak_subscription_preference, presence: true, inclusion: {
    in: %w[physical digital no_subscription]
  }
  validates :digtus_subscription_preference, presence: true, inclusion: {
    in: %w[physical digital no_subscription]
  }

  # Privacy fields
  validates :picture_publication_preference, not_renullable: true, inclusion: {
    in: %w[always_publish always_ask never_publish], allow_nil: true
  }
  validates :user_details_sharing_preference, not_renullable: true, inclusion: {
    in: %w[hidden members_only all_users], allow_nil: true
  }

  # Other
  validates :emergency_number, phone: { possible: true, allow_blank: true }

  before_save :downcase_email!
  before_save :revoke_all_access_tokens, unless: :login_enabled?
  before_create :generate_ical_secret_key
  after_commit :sync_mail_aliases

  scope :activated, -> { where(activated_at: ...Time.zone.now) }
  scope :tomato_users, (-> { where(allow_tomato_sharing: true) })
  scope :login_enabled, (-> { where(login_enabled: true) })
  scope :sidekiq_access, (-> { where(sidekiq_access: true) })
  scope :birthday, (lambda { |month = Time.zone.now.month, day = Time.zone.now.day|
    where('extract (month from birthday) = ? AND extract (day from birthday) = ?', month, day)
  })
  scope :upcoming_birthdays, lambda { |days_ahead = 7|
    range = (0.days.from_now.to_date..days_ahead.days.from_now.to_date)
    scope = range.inject(birthday) do |birthdays, day|
      birthdays.or(birthday(day.month, day.day))
    end
    february28 = Date.new(Time.zone.now.year, 2, 28)
    scope = scope.or(birthday(2, 29)) if range.include?(february28) &&
                                         !Date.leap?(Time.zone.now.year)
    scope
  }
  scope :active_users_for_group, lambda { |group|
    joins(:memberships).merge(Membership.active.where(group:))
  }

  def full_name
    [first_name, last_name_prefix, last_name].compact_blank.join(' ')
  end

  alias to_s full_name

  def username=(value)
    self[:username] = value || generate_username
  end

  def generate_username
    value = [first_name, '.', last_name_prefix, last_name]
            .compact_blank.join.gsub(/\s|-/, '')
            .parameterize.tr('-', '.')
    usernames_like = User.where('username LIKE ?', "#{value}%")
    value = "#{value}#{usernames_like.size}" if usernames_like.any?
    value
  end

  def permission?(action, record)
    @permission_cache ||= {}

    class_name = (record.is_a?(Class) ? record : record.class).name
    permission_name = "#{class_name.underscore}.#{action}"

    return @permission_cache[permission_name] if @permission_cache.key?(permission_name)

    permitted = user_permissions.where(name: permission_name).any? ||
                group_permissions.where(name: permission_name).any?
    @permission_cache[permission_name] = permitted
  end

  def permissions
    Permission.where(id: permission_ids)
  end

  def permission_ids
    user_permissions.map(&:id) + group_permissions.map(&:id)
  end

  def group_permissions
    Permission.joins(:groups_permissions)
              .merge(GroupsPermissions
               .joins(:group)
               .where(group: Group.active_groups_for_user(self)))
  end

  def current_group_member?(group)
    Group.active_groups_for_user(self).include?(group)
  end

  def activation_url
    params = { activation_token: }
    default_options = Rails.application.config.action_mailer.default_url_options
    URI::Generic.build(default_options.merge(path: "/users/#{id}/activate-account",
                                             query: params.to_query)).to_s
  end

  def self.password_reset_url
    default_options = Rails.application.config.action_mailer.default_url_options
    URI::Generic.build(default_options.merge(path: '/users/forgot-password')).to_s
  end

  def activate_account!
    self.activation_token = nil
    self.activated_at = Time.zone.now
    save
  end

  def self.activation_token_hash
    { activation_token: SecureRandom.urlsafe_base64, activation_token_valid_till: 1.day.from_now }
  end

  def self.valid_csv_attributes
    column_names.map(&:to_sym) + %i[full_name avatar_url]
  end

  def to_ical # rubocop:disable Metrics/AbcSize
    return unless birthday

    date = birthday.change(year: Time.zone.now.year)
    date = date.next_year if date < 3.months.ago
    event = Icalendar::Event.new
    event.dtstart     = Icalendar::Values::Date.new(date)
    event.dtend       = Icalendar::Values::Date.new(date.tomorrow)
    event.summary     = "Verjaardag #{full_name}"
    event.description = "#{first_name} wordt vandaag #{date.year - birthday.year} jaar!"
    event
  end

  private

  def downcase_email!
    self.email = email.try(:downcase)
  end

  def revoke_all_access_tokens
    Doorkeeper::AccessToken.revoke_all_for(nil, self)
  end

  def password_when_activated?
    errors.add(:password, 'when activated, user must have password') if activated_at &&
                                                                        password_digest.blank?
  end

  def allow_tomato_sharing_valid?
    return false unless allow_tomato_sharing_changed?(from: true, to: false)

    errors.add(:allow_tomato_sharing,
               'before being removed from sofia your credits needs to be zero.
                Please ask the board to be removed from sofia.')
  end

  def generate_ical_secret_key
    self.ical_secret_key = SecureRandom.hex(32)
  end

  # :nocov:
  def sync_mail_aliases
    return unless Rails.env.production? || Rails.env.staging?

    MailAliasSyncJob.perform_later(mail_aliases.ids) if mail_aliases.any?
    MailAliasSyncJob.perform_later(group_mail_aliases.ids) if group_mail_aliases.any?
  end
  # :nocov:
end
