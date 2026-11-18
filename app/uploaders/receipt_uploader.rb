class ReceiptUploader < ApplicationUploader
  IMAGE_CONTENT_TYPES = %w[image/jpeg image/png].freeze

  # Images are flattened and converted to JPG so Prawn can always embed them in the declaration PDF
  process :normalize_image, if: :image?

  # Receipts contain personal data, so they are stored outside public/ and only served
  # through DeclarationsController#receipt after authorization
  def root
    Rails.root.join('private_uploads').to_s
  end

  def extension_allowlist
    %w[jpg jpeg png pdf]
  end

  def content_type_allowlist
    IMAGE_CONTENT_TYPES + %w[application/pdf]
  end

  def size_range
    (1..(10.megabytes))
  end

  def max_pixel_dimensions
    [8192, 8192]
  end

  def image?(new_file = file)
    new_file.present? && IMAGE_CONTENT_TYPES.include?(new_file.content_type)
  end

  def pdf?(new_file = file)
    new_file.present? && new_file.content_type == 'application/pdf'
  end

  private

  def normalize_image(_file = nil)
    minimagick! do |builder|
      builder.resize_to_limit(2000, 2000).background('white').flatten.saver(quality: 85).convert('jpg')
    end
  end

  # The image bomb check only applies to images, a PDF receipt has no pixel dimensions
  def protect_from_image_bomb!(new_file)
    return if pdf?(new_file)

    super
  end
end
