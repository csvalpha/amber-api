class MailModerationReminderJob < ApplicationJob
  queue_as :default

  def perform
    StoredMail.all.where('created_at <= ?', 6.hours.ago).group_by(&:mail_alias_id)
              .each do |mail_alias_id, to_be_moderated_mails|
      MailAlias.find(mail_alias_id).moderators.each do |moderator|
        MailModerationReminderMailer.moderation_reminder_email(moderator, to_be_moderated_mails)
                                    .deliver_later
      end
    end
  end
end
