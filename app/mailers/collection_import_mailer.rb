class CollectionImportMailer < ApplicationMailer
  def success_report_mail(user, collection)
    @user = user
    @collection = collection
    mail to: user.email, subject: '[SUCCESS] Report voor collection import job' # rubocop:disable Rails/I18nLocaleTexts
  end

  def error_report_mail(user, collection, errors)
    @user = user
    @collection = collection
    @errors = errors
    mail to: user.email, subject: '[FAILED] Report voor collection import job' # rubocop:disable Rails/I18nLocaleTexts
  end
end
