class MailModerationReminderJob < ApplicationJob
  queue_as :default

  def perform(stored_mail)
    return unless stored_mail

    stored_mail.mail_alias.moderators.each do |moderator|
      MailModerationMailer.reminder_for_moderation_email(moderator, stored_mail).deliver_later
    end

    # Only reschedule if mail doesn't expire next day
    return unless Time.zone.now + 25.hours < stored_mail.created_at + 3.days

    Sidekiq.set_schedule("mail_reminder_#{stored_mail.id}", 'in' => ['24h'], 'class' =>
      'MailModerationReminderJob', args: [stored_mail])
  end
end
