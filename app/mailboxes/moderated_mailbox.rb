class ModeratedMailbox < ApplicationMailbox
  def process # rubocop:disable Metrics/AbcSize
    # Do not use mail.to, this contains all recipients.
    # If there are 2 recipients of alpha this method will be called twice
    to = inbound_email.mail['Delivered-To'].value
    mail_alias = MailAlias.find_by(email: to, moderation_type: 'moderated')
    return unless mail_alias

    stored_mail = StoredMail.create(mail_alias: mail_alias, inbound_email: inbound_email)

    mail_alias.moderators.sample(2).each do |moderator|
      MailModerationMailer.request_for_moderation_email(moderator, stored_mail).deliver_later
    end
    MailModerationMailer.awaiting_moderation_email(stored_mail.sender, stored_mail).deliver_later
    MailModerationReminderJob.set(wait: 24.hours).perform_later(stored_mail.id)
  end
end
