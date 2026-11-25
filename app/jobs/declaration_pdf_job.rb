class DeclarationPdfJob < ApplicationJob
  queue_as :default

  retry_on NextcloudWebdav::Error, HTTP::Error, wait: :polynomially_longer, attempts: 5
  discard_on ActiveJob::DeserializationError

  def perform(declaration)
    return if declaration.approved_at.blank? || declaration.rejected?
    return Rails.logger.warn('Nextcloud not configured, skipping declaration PDF') unless NextcloudWebdav.configured?

    path = upload(declaration)
    declaration.update_columns(pdf_path: path, pdf_uploaded_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
  end

  private

  def upload(declaration)
    pdf = DeclarationPdf.new(declaration)
    path = File.join(Rails.application.config.x.nextcloud_declarations_path, pdf.folder, pdf.filename)
    client = NextcloudWebdav.from_config

    client.upload(path, pdf.render)
    # Upload first, so the old file is only removed once the new version is safely stored
    client.delete(declaration.pdf_path) if declaration.pdf_path.present? && declaration.pdf_path != path
    path
  end
end
