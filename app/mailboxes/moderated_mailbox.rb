# :nocov:
class ModeratedMailbox < ApplicationMailbox
  def process # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    recipients = inbound_email.mail.to
    recipients.each do |recipient|
      mail_alias = MailAlias.find_by(email: recipient, moderation_type: 'moderated')
      next unless mail_alias

      # Since mail.to contains all recipients, and this function is called once per moderated
      # recipient we need to check if a stored mail has already been created for this inbound_email
      message_id = inbound_email.message_id
      inbound_email_ids = ActionMailbox::InboundEmail.select('id').where(message_id:)
      next if StoredMail.with_deleted
                        .where(mail_alias:)
                        .exists?(inbound_email_id: inbound_email_ids)

      stored_mail = StoredMail.create(mail_alias:, inbound_email:)

      mail_alias.moderators.each do |moderator|
        MailModerationMailer.request_for_moderation_email(moderator, stored_mail).deliver_later
      end
      MailModerationMailer.awaiting_moderation_email(stored_mail.sender, stored_mail).deliver_later
      MailModerationReminderJob.set(wait: 24.hours).perform_later(stored_mail.id)
    end
  end
end
