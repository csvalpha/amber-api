class MailModerationReminderMailer < ApplicationMailer
  def moderation_reminder_email(user, to_be_moderated_mails)
    @to_be_moderated_mails = to_be_moderated_mails
    subject = "Er moeten nog #{@to_be_moderated_mails.count} mails"\
              ' gemodereerd worden!'

    mail to: user.email, subject: subject
  end
end
