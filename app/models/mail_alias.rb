class MailAlias < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :moderator_group, class_name: 'Group'

  validates :email, presence: true, uniqueness: true
  validates :moderation_type, inclusion: %w[open semi_moderated moderated]
  validates :smtp_enabled, inclusion: [true, false]
  validate :group_xor_user?
  validate :known_mail_domain?
  validate :when_moderated_with_moderator?

  before_validation :downcase_email

  before_save :set_smtp

  scope :mail_aliases_moderated_by_user, (lambda { |user|
    joins(:moderator_group).where(moderator_group: Group.active_groups_for_user(user))
  })

  def mail_addresses
    return [user.email] if user

    User.active_users_for_group(group).pluck(:email)
  end

  def moderators
    User.active_users_for_group(moderator_group)
  end

  def to_s
    return "#{user.full_name} <#{email}>" if user

    "#{group.name} <#{email}>"
  end

  def domain
    email.split('@').last
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def group_xor_user?
    errors.add(:base, 'Must have either one group OR one user') unless (group && !user) || (!group && user) # rubocop:disable Metrics/LineLength
  end

  def known_mail_domain?
    errors.add(:email, "Must end with a known domain (#{known_mail_domains.join(', ')})") unless email.ends_with?(*known_mail_domains) # rubocop:disable Metrics/LineLength
  end

  def when_moderated_with_moderator?
    errors.add(:base, "Must have a moderator, as moderation type is #{moderation_type}") if %w[semi_moderated moderated].include?(moderation_type) && !moderator_group # rubocop:disable Metrics/LineLength
    errors.add(:base, 'Must have no moderator, as moderation type is open') if moderation_type == 'open' && moderator_group # rubocop:disable Metrics/LineLength
  end

  def known_mail_domains
    Rails.application.config.x.mail_domains
  end

  def set_smtp
    return unless smtp_enabled_changed?

    enable_smtp if smtp_enabled
    disable_smtp unless smtp_enabled
  end

  def enable_smtp
    password = SecureRandom.hex(16)
    mailgun_client.post("/domains/#{domain}/credentials", 'login': email, 'password': password)
    MailSMTPMailer.enabled_email(self, password).deliver_later
  end

  def disable_smtp
    mailgun_client.delete("/domains/#{domain}/credentials/#{email}")
    MailSMTPMailer.disabled_email(self).deliver_later

  end

  def mailgun_client
    api_key = Rails.application.config.x.mailgun_api_key
    api_host = Rails.application.config.x.mailgun_host
    @mailgun_client = Mailgun::Client.new api_key, api_host
  end


end
