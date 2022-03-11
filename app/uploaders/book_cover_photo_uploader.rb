class BookCoverPhotoUploader < ApplicationImageUploader
  process resize_to_fill: [360, 540]
end
