class MailAlias < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :user, optional: true
  belongs_to :moderator_group, class_name: 'Group', optional: true

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

  def mail_addresses_str
    mail_addresses.join(',')
  end

  def alias_name
    email.split("@").first
  end

  def domain
    email.split('@').last
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def group_xor_user?
    return if (group && !user) || (!group && user)

    errors.add(:base, 'Must have either one group OR one user')
  end

  def known_mail_domain?
    return if email.ends_with?(*known_mail_domains)

    errors.add(:email, "Must end with a known domain (#{known_mail_domains.join(', ')})")
  end

  def when_moderated_with_moderator?
    if %w[semi_moderated moderated].include?(moderation_type) && !moderator_group
      errors.add(:base, "Must have a moderator, as moderation type is #{moderation_type}")
    end
    if moderation_type == 'open' && moderator_group
      errors.add(:base, 'Must have no moderator, as moderation type is open')
    end
  end

  def known_mail_domains
    Rails.application.config.x.mail_domains
  end

  # :nocov:
  def set_smtp
    return unless smtp_enabled_changed?

    SmtpJob.perform_later(self, smtp_enabled)
  end
  # :nocov:
end
