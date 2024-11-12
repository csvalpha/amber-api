class UserExportMailer < ApplicationMailer
  def privacy_notification_email(exporting_user, group, fields, description)
    @exporting_user = exporting_user
    @group = group
    @fields = fields
    @description = description
    mail to: Rails.application.config.x.privacy_email,
    subject: '[Privacy] Er is een database-export gemaakt' # rubocop:disable Rails/I18nLocaleTexts
  end
end
