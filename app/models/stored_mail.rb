class StoredMail < ApplicationRecord
  belongs_to :mail_alias
  belongs_to :inbound_email, class_name: 'ActionMailbox::InboundEmail'

  scope :stored_mails_moderated_by_user, lambda { |user|
    joins(:mail_alias).merge(MailAlias.mail_aliases_moderated_by_user(user))
  }

  # Define some getters
  def received_at
    inbound_email.mail.date
  end

  def sender
    inbound_email.mail.from.first
  end

  def subject
    inbound_email.mail.subject
  end
end
