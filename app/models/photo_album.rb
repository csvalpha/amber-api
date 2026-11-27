require 'zip'

class PhotoAlbum < ApplicationRecord
  has_paper_trail
  has_many :photos, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true

  # public: everyone, alumni: everyone with read permission,
  # members: only users who were a member around the date of the album
  VISIBILITIES = %w[public alumni members].freeze

  validates :title, presence: true
  validates :visibility, inclusion: { in: VISIBILITIES }

  scope :publicly_visible, -> { where(visibility: 'public') }

  scope :visible_in_period, lambda { |from, to|
    where(visibility: %w[public alumni]).or(
      where('COALESCE(photo_albums.date, CAST(photo_albums.created_at AS date)) BETWEEN ? AND ?', from, to)
    )
  }

  scope :without_photo_tags, lambda {
    tag_percentage_threshold = 0.85
    qualifying_album_ids_subquery = unscoped
                                    .joins(:photos)
                                    .left_joins(photos: :tags)
                                    .group('photo_albums.id')
                                    .having(
                                      'COALESCE(COUNT(DISTINCT photo_tags.photo_id), 0) * 1.0 / ' \
                                      'NULLIF(COUNT(DISTINCT photos.id), 0) < ?',
                                      tag_percentage_threshold
                                    )
                                    .select('photo_albums.id')
    where(id: qualifying_album_ids_subquery)
  }

  def owners
    if group.present?
      group.active_users + [author]
    else
      [author]
    end
  end

  def to_zip
    temp_file = Tempfile.new('test.zip')

    Zip::File.open(temp_file.path, create: true) do |file|
      photos.each do |photo|
        file.add("#{photo.id}.#{photo.image.file.extension}", photo.image.path)
      end
    end

    File.read(temp_file.path)
  end
end
