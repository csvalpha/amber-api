require 'exifr/jpeg'

class Photo < ApplicationRecord
  META_FIELDS = %i[make model date_time_original exposure_time aperture_value
                   iso_speed_ratings copyright lens_model focal_length].freeze

  belongs_to :photo_album
  belongs_to :uploader, class_name: 'User'
  has_many :comments, class_name: 'PhotoComment',
                      dependent: :destroy, counter_cache: :comments_count

  mount_uploader :image, PhotoUploader
  has_paper_trail skip: [:image]

  validates :image, presence: true
  validates :original_filename, presence: true
  validates :uploader, presence: true
  validates :photo_album, presence: true

  scope :with_comments, (lambda {
    joins(:comments).distinct
  })

  scope :publicly_visible, (lambda {
    joins(:photo_album).where(photo_albums: { publicly_visible: true })
  })

  before_save :extract_exif

  def extract_exif
    return unless jpeg?

    data = EXIFR::JPEG.new(image.file.file)

    META_FIELDS.each do |field|
      public_send("exif_#{field}=", data.public_send(field)) if data.public_send(field).present?
    end
  end

  def jpeg?
    image.file.extension.casecmp('jpg').zero? || image.file.extension.casecmp('jpeg').zero?
  end
end
