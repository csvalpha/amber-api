require 'zip'

class PhotoAlbum < ApplicationRecord
  has_paper_trail
  has_many :photos, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true

  validates :title, presence: true
  validates :publicly_visible, inclusion: [true, false]

  scope :publicly_visible, -> { where(publicly_visible: true) }

  scope :without_photo_tags, lambda {
    qualifying_album_ids_subquery = self.unscoped
      .joins(:photos)
      .left_joins(photos: :tags) 
      .group('photo_albums.id')
      .having(<<~SQL.squish)
        (
          COALESCE(COUNT(DISTINCT photo_tags.photo_id), 0) * 1.0 / COUNT(DISTINCT photos.id)
        ) < 0.85
      SQL
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

    Zip::File.open(temp_file.path, Zip::File::CREATE) do |file|
      photos.each do |photo|
        file.add("#{photo.id}.#{photo.image.file.extension}", photo.image.path)
      end
    end

    File.read(temp_file.path)
  end
end
