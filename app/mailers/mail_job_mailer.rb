class MailJobMailer < ApplicationMailer
  def report_email(user, recipients, message, subject)
    @user = user
    @recipients = recipients
    @message = message
    mail to: user.email, subject: "Afleverrapport voor #{subject}"
  end
end
