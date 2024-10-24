class PhotoUploader < ApplicationImageUploader
  version :thumb do
    process resize_to_fill: [256, 256]
  end

  version :medium do
    process resize_to_fill: [512, 384]
  end

  def store_dir
    "uploads/photo_albums/#{model.photo_album_id}/photos/#{model.id}"
  end
end
