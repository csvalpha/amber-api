class ActivityMailerJob < ApplicationJob
  queue_as :default

  def perform(from, activity, message)
    responses = activity.form.responses.completed.includes(:user)
    responses.each do |response|
      to = response.user
      ActivityMailer.enrolled_email(to, activity, message).deliver_later
    end

    recipients = responses.map(&:user)
    subject = "[Activiteit] Informatiemail over #{activity.title}"
    MailJobMailer.report_email(from, recipients, message, subject).deliver_later
  end
end
