class ApplicationImageUploader < ApplicationUploader
  process resize_to_limit: [2048, 2048]

  def extension_allowlist
    %w[jpg jpeg png]
  end

  def content_type_allowlist
    %w[image/png image/jpeg]
  end
end
