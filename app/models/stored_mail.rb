class StoredMail < ApplicationRecord
  belongs_to :mail_alias
  belongs_to :inbound_email, class_name: 'ActionMailbox::InboundEmail'

  validates :received_at, presence: true, if: :mailgun_mail?
  validates :sender, presence: true, if: :mailgun_mail?
  validates :mail_alias, presence: true

  scope :stored_mails_moderated_by_user, (lambda { |user|
    joins(:mail_alias).merge(MailAlias.mail_aliases_moderated_by_user(user))
  })

  def mailgun_mail?
    # Temp method to check if it is a mailgun mail
    return message_url.present?
  end

  # Define some legacy fallbacks
  def received_at
    return self[:received_at] if self[:received_at].present?

    inbound_email.mail.date
  end

  def sender
    return self[:sender] if self[:sender].present?

    inbound_email.mail.from.first
  end

  def subject
    return self[:subject] if self[:subject].present?

    inbound_email.mail.subject
  end
end
