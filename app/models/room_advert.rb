class RoomAdvert < ApplicationRecord
  mount_base64_uploader :cover_photo, CoverPhotoUploader

  belongs_to :author, class_name: 'User'

  validates :house_name, presence: true
  validates :contact, presence: true
  validates :description, presence: true
  validates :publicly_visible, inclusion: [true, false]
  validates :available_from, presence: true

  scope :publicly_visible, (-> { where(publicly_visible: true) })
end
