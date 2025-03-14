class MailModerationReminderJob < ApplicationJob
  queue_as :default

  def perform(stored_mail_id)
    stored_mail = StoredMail.find_by(id: stored_mail_id)

    return unless stored_mail

    stored_mail.mail_alias.moderators.each do |moderator|
      MailModerationMailer.reminder_for_moderation_email(moderator, stored_mail).deliver_later
    end

    MailModerationReminderJob.set(wait: 24.hours).perform_later(stored_mail_id) unless Rails.env.development?
  end
end
