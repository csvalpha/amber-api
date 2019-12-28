class MailModerationReminderJob < ApplicationJob
  queue_as :default

  def perform(stored_mail)
    return unless stored_mail


    stored_mail.mail_alias.moderators.each do |moderator|
      MailModerationMailer.reminder_for_moderation_email(moderator, stored_mail).deliver_later
    end

    # Only reschedule if mail doesn't expire next day
    return unless Time.zone.now + 25.hours < stored_mail.received_at + 3.days

      #MailModerationReminderJob.set(wait: 24.hours).perform_later(stored_mail)
  end
end
