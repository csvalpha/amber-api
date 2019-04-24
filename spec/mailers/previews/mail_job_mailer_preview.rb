# Preview all emails at http://localhost:3000/rails/mailers/mail_job_mailer
class MailJobMailerPreview < ActionMailer::Preview
  def report_email
    from = User.first
    recipients = User.all.sample(5)
    message = Faker::Hipster.paragraph
    subject = Faker::Book.title
    MailJobMailer.report_email(from, recipients, message, subject)
  end
end
