require 'exifr/jpeg'

class Photo < ApplicationRecord
  META_FIELDS = %i[make model date_time_original exposure_time aperture_value
                   iso_speed_ratings copyright lens_model focal_length].freeze

  belongs_to :photo_album
  belongs_to :uploader, class_name: 'User'
  has_many :comments, class_name: 'PhotoComment',
                      dependent: :destroy, counter_cache: :comments_count
  has_many :tags, class_name: 'PhotoTag',
                  dependent: :destroy, counter_cache: :tags_count

  mount_uploader :image, PhotoUploader
  has_paper_trail skip: [:image]

  validates :image, presence: true
  validates :original_filename, presence: true

  scope :with_comments, lambda {
    joins(:comments).distinct
  }

  scope :alumni_visible, lambda { |start_date, end_date|
    joins(:photo_album)
      .where(photo_albums: { visibility: 'alumni' })
      .or(photo_albums: { visibility: 'public' })
      .or(where.not(photo_albums: { date: nil }).where(photo_albums: { date: start_date..end_date }))
      .or(where(photo_albums: { date: nil }).where(photo_albums: { created_at: start_date..end_date }))
  }

  scope :with_tags, lambda {
    joins(:tags).distinct
  }

  before_save :extract_exif

  def extract_exif # rubocop:disable Metrics/MethodLength
    return unless jpeg?

    data = EXIFR::JPEG.new(image.file.file)

    META_FIELDS.each do |field|
      next if data.public_send(field).blank?

      value = data.public_send(field)
      if value.is_a? String
        value = value.encode('UTF-8', invalid: :replace, undef: :replace,
                                      replace: '')
      end
      public_send(:"exif_#{field}=", value)
    end
  end

  private

  def jpeg?
    image.file.extension.casecmp('jpg').zero? || image.file.extension.casecmp('jpeg').zero?
  end
end
