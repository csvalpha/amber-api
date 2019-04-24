class CoverPhotoUploader < ApplicationImageUploader
  process resize_to_fill: [640, 360]
end
