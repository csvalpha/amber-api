require 'carrierwave/uploader/magic_mime_whitelist'

class ApplicationImageUploader < ApplicationUploader
  include CarrierWave::Uploader::MagicMimeWhitelist

  process resize_to_limit: [2048, 2048]

  def extension_whitelist
    %w[jpg jpeg png]
  end

  def whitelist_mime_type_pattern
    %r{image/png|image/jpeg}
  end
end
