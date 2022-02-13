class Book < ApplicationRecord
  mount_base64_uploader :cover_photo, BookCoverPhotoUploader

  validates :title, presence: true
  validates :isbn, isbn_format: { allow_nil: true }
end
