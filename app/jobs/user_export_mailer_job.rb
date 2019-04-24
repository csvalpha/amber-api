class UserExportMailerJob < ApplicationJob
  queue_as :default

  def perform(exporting_user, group, fields, description)
    UserExportMailer.privacy_notification_email(
      exporting_user, group, fields, description
    ).deliver_later
  end
end
