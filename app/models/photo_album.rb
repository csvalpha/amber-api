require 'zip'

class PhotoAlbum < ApplicationRecord
  has_paper_trail
  has_many :photos, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true

  validates :title, presence: true
  validates :visibility, inclusion: { in: %w[public alumni members] }

  scope :publicly_visible, lambda {
    joins(:photo_album).where(photo_albums: { visibility: 'public' })
  }
  scope :alumni_visible, lambda { |start_date, end_date|
  joins(:photo_album)
    .where(photo_albums: { visibility: 'alumni' })
    .or(photo_albums: { visibility: 'public' })
    .or(where.not(date: nil).where(date: start_date..end_date))
    .or(where(date: nil).where(created_at: start_date..end_date))
  }
  scope :without_photo_tags, lambda {
    where.not(id: Photo.joins(:tags).select(:photo_album_id).distinct)
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
