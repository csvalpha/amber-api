class StoredMail < ApplicationRecord
  belongs_to :mail_alias

  validates :message_url, presence: true
  validates :received_at, presence: true
  validates :sender, presence: true
  validates :mail_alias, presence: true

  scope :stored_mails_moderated_by_user, (lambda { |user|
    joins(:mail_alias).merge(MailAlias.mail_aliases_moderated_by_user(user))
  })
end
