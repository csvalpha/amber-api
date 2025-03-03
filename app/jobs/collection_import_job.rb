require 'http'

class CollectionImportJob < ApplicationJob
  include SpreadsheetHelper
  queue_as :default

  def perform(base64_data, collection, job_user)
    @model = collection
    @user = job_user
    result = bulk_import_transactions(base64_data)
    report_to_mail(result)
  end

  private

  def bulk_import_transactions(base64_data)
    return true if base64_data.blank?

    file = decode_upload_file(base64_data)
    importer = Import::Transaction.new(file, @model)
    importer.import!
  end

  def report_to_mail(result)
    if result
      CollectionImportMailer.success_report_mail(
        @user, @model
      ).deliver_later
    else
      CollectionImportMailer.error_report_mail(
        @user, @model, Array(@model.errors.messages[:import_file])
      ).deliver_later
    end
  end
end
