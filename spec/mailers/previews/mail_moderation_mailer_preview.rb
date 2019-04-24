# Preview all emails at http://localhost:3000/rails/mailers/mail_moderation_mailer
class MailModerationMailerPreview < ActionMailer::Preview
  def request_for_moderation
    user = User.first
    stored_mail = StoredMail.first
    MailModerationMailer.request_for_moderation_email(user, stored_mail)
  end

  def awaiting_moderation_email
    user = User.first.email
    stored_mail = StoredMail.first
    MailModerationMailer.awaiting_moderation_email(user, stored_mail)
  end

  def accept
    sender = User.first.email
    stored_mail = StoredMail.first
    approver = User.first
    MailModerationMailer.accept_email(sender, stored_mail, approver)
  end

  def reject
    sender = User.first.email
    stored_mail = StoredMail.first
    approver = User.first
    MailModerationMailer.reject_email(sender, stored_mail, approver)
  end
end
